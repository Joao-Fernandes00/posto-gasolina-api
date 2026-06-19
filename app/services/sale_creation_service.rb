class SaleCreationService
  class Error < StandardError
    attr_reader :details

    def initialize(message, details = nil)
      super(message)
      @details = details
    end
  end

  MONEY_SCALE = 2

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @params = params.to_h.deep_symbolize_keys
    @sale_items = []
  end

  def call
    ActiveRecord::Base.transaction do
      load_sale_context!
      validate_payments_presence!
      build_items!
      build_payments!
      validate_payment_total!
      create_sale!
      persist_items!
      persist_payments!

      @sale
    end
  end

  private

  attr_reader :params, :sale_items, :payments

  def load_sale_context!
    @sold_at = parse_datetime(params[:vendida_em]) || Time.current
    @cash_register = Caixa.lock.find(params[:caixa_id])
    fail!("caixa deve estar aberto") unless cash_register.status == "aberto" && cash_register.fechado_em.blank?

    @employee = Funcionario.find(params[:funcionario_id])
    fail!("funcionario deve ser o responsavel pelo caixa") unless cash_register.funcionario_id == employee.id

    @customer = Cliente.find(params[:cliente_id]) if params[:cliente_id].present?
    fail!("cliente deve estar ativo") if customer.present? && !customer.ativo?

    @vehicle = Veiculo.find(params[:veiculo_id]) if params[:veiculo_id].present?
    fail!("veiculo deve estar ativo") if vehicle.present? && !vehicle.ativo?

    validate_vehicle_customer!
  end

  def validate_vehicle_customer!
    return if customer.blank? || vehicle.blank?
    return if vehicle.cliente_id == customer.id
    return if vehicle.frota&.cliente_id == customer.id

    fail!("veiculo nao pertence ao cliente informado")
  end

  def validate_payments_presence!
    fail!("informe ao menos uma forma de pagamento") if payment_params.blank?
  end

  def build_items!
    fail!("informe ao menos um item de venda") if item_params.blank?

    item_params.each do |item|
      if item[:bico_id].present? || item[:combustivel_id].present?
        build_fuel_item!(item)
      elsif item[:produto_id].present?
        build_product_item!(item)
      else
        fail!("item deve informar combustivel ou produto")
      end
    end
  end

  def build_fuel_item!(item)
    quantity = parse_decimal!(item[:quantidade], "quantidade")
    fail!("quantidade deve ser maior que zero") unless quantity.positive?

    nozzle = Bico.lock.find(item[:bico_id])
    tank = nozzle.tanque
    tank.lock!
    fuel = tank.combustivel

    if item[:combustivel_id].present? && item[:combustivel_id].to_i != fuel.id
      fail!("combustivel informado nao corresponde ao bico")
    end

    validate_vehicle_fuel!(fuel)
    price_history = fuel.preco_vigente(em: sold_at)
    fail!("combustivel sem preco vigente") if price_history.blank?
    fail!("volume insuficiente no tanque") if tank.volume_atual_litros < quantity

    unit_price = decimal(price_history.preco)
    discount = parse_optional_decimal!(item[:desconto], "desconto", default: 0)
    total = money((unit_price * quantity) - discount)
    fail!("desconto do item excede o total") if total.negative?

    tank.volume_atual_litros -= quantity
    nozzle.encerrante_litros += quantity
    tank.save!
    nozzle.save!

    sale_items << {
      bico: nozzle,
      combustivel: fuel,
      descricao: item[:descricao].presence || fuel.nome,
      quantidade: quantity,
      valor_unitario: unit_price,
      desconto: discount,
      total:
    }
  end

  def validate_vehicle_fuel!(fuel)
    return if vehicle.blank? || vehicle.tipo.blank?
    return if normalize(vehicle.tipo) == normalize(fuel.tipo)

    fail!("combustivel nao autorizado para o veiculo")
  end

  def build_product_item!(item)
    quantity = parse_decimal!(item[:quantidade], "quantidade")
    fail!("quantidade deve ser maior que zero") unless quantity.positive?

    product = Produto.lock.find(item[:produto_id])
    stock = product.estoque
    fail!("produto sem estoque cadastrado") if stock.blank?

    stock.lock!
    fail!("estoque insuficiente do produto") if stock.quantidade < quantity

    unit_price = decimal(product.preco_venda)
    discount = parse_optional_decimal!(item[:desconto], "desconto", default: 0)
    total = money((unit_price * quantity) - discount)
    fail!("desconto do item excede o total") if total.negative?

    stock.quantidade -= quantity
    stock.save!

    sale_items << {
      produto: product,
      descricao: item[:descricao].presence || product.nome,
      quantidade: quantity,
      valor_unitario: unit_price,
      desconto: discount,
      total:
    }
  end

  def build_payments!
    @payments = payment_params.map do |payment|
      {
        caixa: cash_register,
        forma_pagamento: FormaPagamento.find_by(chave: payment[:forma]),
        forma: payment[:forma],
        valor: money(parse_decimal!(payment[:valor], "valor")),
        status: payment[:status].presence || "aprovado",
        pago_em: parse_datetime(payment[:pago_em]) || sold_at,
        nsu: payment[:nsu],
        codigo_autorizacao: payment[:codigo_autorizacao]
      }
    end
  end

  def validate_payment_total!
    fail!("informe ao menos um item de venda") if subtotal.zero?

    if payments.sum { |payment| payment.fetch(:valor) } != total
      fail!("soma dos pagamentos deve ser igual ao total da venda")
    end
  end

  def create_sale!
    @sale = Venda.create!(
      cliente: customer,
      funcionario: employee,
      caixa: cash_register,
      veiculo: vehicle,
      numero: params[:numero],
      vendida_em: sold_at,
      subtotal: subtotal,
      desconto: sale_discount,
      total: total,
      status: "finalizada"
    )
  end

  def persist_items!
    sale_items.each do |item|
      @sale.venda_itens.create!(item)
    end
  end

  def persist_payments!
    payments.each do |payment|
      @sale.pagamentos.create!(payment)
    end
  end

  def item_params
    Array(params[:itens] || params[:items])
  end

  def payment_params
    Array(params[:pagamentos] || params[:payments])
  end

  def subtotal
    @subtotal ||= money(sale_items.sum { |item| item.fetch(:total) })
  end

  def sale_discount
    @sale_discount ||= parse_optional_decimal!(params[:desconto], "desconto", default: 0).then { |value| money(value) }
  end

  def total
    @total ||= begin
      calculated_total = subtotal - sale_discount
      fail!("desconto da venda excede o subtotal") if calculated_total.negative?

      money(calculated_total)
    end
  end

  def sold_at
    @sold_at
  end

  def cash_register
    @cash_register
  end

  def employee
    @employee
  end

  def customer
    @customer
  end

  def vehicle
    @vehicle
  end

  def parse_decimal!(value, field)
    fail!("#{field} deve ser informado") if value.blank?

    decimal(value)
  rescue ArgumentError
    fail!("#{field} deve ser decimal")
  end

  def parse_optional_decimal!(value, field, default:)
    return BigDecimal(default.to_s) if value.blank?

    parse_decimal!(value, field)
  end

  def decimal(value)
    value.is_a?(BigDecimal) ? value : BigDecimal(value.to_s)
  end

  def money(value)
    decimal(value).round(MONEY_SCALE)
  end

  def parse_datetime(value)
    return if value.blank?

    Time.zone.parse(value.to_s)
  rescue ArgumentError
    fail!("data invalida")
  end

  def normalize(value)
    value.to_s.strip.downcase
  end

  def fail!(message, details = nil)
    raise Error.new(message, details)
  end
end
