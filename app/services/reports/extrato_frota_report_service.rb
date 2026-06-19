module Reports
  class ExtratoFrotaReportService
    MONTH_FORMAT = /\A\d{4}-\d{2}\z/

    def self.call(params = {})
      new(params).call
    end

    def initialize(params = {})
      @params = params.to_h.symbolize_keys
    end

    def call
      validate_month!

      sales_totals.map do |(customer_id, vehicle_id), total|
        customer = customers.fetch(customer_id)
        vehicle = vehicles.fetch(vehicle_id)

        {
          cliente_id: customer_id,
          cliente_nome: customer_name(customer),
          veiculo_id: vehicle_id,
          veiculo_placa: vehicle.placa,
          total_gasto: total,
          litros: liter_totals.fetch([ customer_id, vehicle_id ], BigDecimal("0")),
          quantidade_vendas: sale_counts.fetch([ customer_id, vehicle_id ], 0)
        }
      end
    end

    private

    attr_reader :params

    def filtered_sales
      relation = Venda.completed.where(vendida_em: month_range).where.not(cliente_id: nil, veiculo_id: nil)
      relation = relation.where(cliente_id: params[:cliente_id]) if params[:cliente_id].present?
      relation
    end

    def sales_totals
      @sales_totals ||= filtered_sales.group(:cliente_id, :veiculo_id).sum(:total)
    end

    def sale_counts
      @sale_counts ||= filtered_sales.group(:cliente_id, :veiculo_id).count
    end

    def liter_totals
      @liter_totals ||= VendaItem
        .joins(:venda)
        .where(venda: filtered_sales.select(:id))
        .where.not(combustivel_id: nil)
        .group("vendas.cliente_id", "vendas.veiculo_id")
        .sum(:quantidade)
    end

    def customers
      @customers ||= Cliente.where(id: sales_totals.keys.map(&:first)).includes(:pessoa_fisica, :pessoa_juridica).index_by(&:id)
    end

    def vehicles
      @vehicles ||= Veiculo.where(id: sales_totals.keys.map(&:last)).index_by(&:id)
    end

    def customer_name(customer)
      customer.pessoa_fisica&.nome || customer.pessoa_juridica&.razao_social || "Cliente #{customer.id}"
    end

    def month_range
      @month_range ||= begin
        month = Date.strptime(params[:mes], "%Y-%m")
        month.beginning_of_month.beginning_of_day..month.end_of_month.end_of_day
      end
    end

    def validate_month!
      raise ReportError, "mes deve estar no formato AAAA-MM" unless params[:mes].to_s.match?(MONTH_FORMAT)

      Date.strptime(params[:mes], "%Y-%m")
    rescue Date::Error
      raise ReportError, "mes deve estar no formato AAAA-MM"
    end
  end
end
