require "test_helper"

class ReportsTest < ActionDispatch::IntegrationTest
  test "vendas por turno agrupa por caixa e turno sem duplicar totais por itens" do
    contexto = create_cash_context
    combustivel = create_fuel
    produto = create_product(nome: "Agua Mineral", sku: "AGUA-#{unique_suffix}")

    sale_one = create_sale(contexto:, numero: "VT-#{unique_suffix}-1", total: 100, vendida_em: Time.zone.local(2026, 6, 10, 9))
    create_fuel_item(sale_one, combustivel:, quantidade: 10, total: 60)
    create_product_item(sale_one, produto:, quantidade: 2, total: 40)

    sale_two = create_sale(contexto:, numero: "VT-#{unique_suffix}-2", total: 50, vendida_em: Time.zone.local(2026, 6, 10, 10))
    create_fuel_item(sale_two, combustivel:, quantidade: 5, total: 50)

    sale_outside_filter = create_sale(contexto:, numero: "VT-#{unique_suffix}-3", total: 70, vendida_em: Time.zone.local(2026, 6, 12, 10))
    create_fuel_item(sale_outside_filter, combustivel:, quantidade: 7, total: 70)

    get "/relatorios/vendas-turno", params: { inicio: "2026-06-10T00:00:00", fim: "2026-06-10T23:59:59" }

    assert_response :success
    body = response.parsed_body
    assert_equal 1, body.size

    row = body.first
    assert_equal contexto.fetch(:caixa).id, row.fetch("caixa_id")
    assert_equal contexto.fetch(:turno).id, row.fetch("turno_id")
    assert_equal BigDecimal("150"), decimal(row.fetch("total_financeiro"))
    assert_equal BigDecimal("15"), decimal(row.fetch("volume_litros"))
  end

  test "estoque critico retorna produtos ativos abaixo do minimo com dados de oleo" do
    categoria = Categoria.create!(nome: "Lubrificantes #{unique_suffix}")
    critical = Produto.create!(categoria:, nome: "Oleo 15W40", sku: "OLEO-#{unique_suffix}", preco_venda: 30)
    Estoque.create!(produto: critical, quantidade: 2, quantidade_minima: 5, localizacao: "A1")
    Oleo.create!(produto: critical, viscosidade: "15W40", especificacao: "API SN", volume_litros: 1)

    healthy = Produto.create!(categoria:, nome: "Filtro", sku: "FILTRO-#{unique_suffix}", preco_venda: 25)
    Estoque.create!(produto: healthy, quantidade: 10, quantidade_minima: 5)

    inactive = Produto.create!(categoria:, nome: "Oleo Inativo", sku: "INATIVO-#{unique_suffix}", preco_venda: 20, ativo: false)
    Estoque.create!(produto: inactive, quantidade: 1, quantidade_minima: 5)

    get "/relatorios/estoque-critico"

    assert_response :success
    body = response.parsed_body
    assert_equal [ critical.id ], body.map { |row| row.fetch("produto_id") }

    row = body.first
    assert_equal "Oleo 15W40", row.fetch("nome")
    assert_equal BigDecimal("2"), decimal(row.fetch("estoque_atual"))
    assert_equal BigDecimal("5"), decimal(row.fetch("estoque_minimo"))
    assert_equal "15W40", row.dig("oleo", "viscosidade")
    assert_equal "API SN", row.dig("oleo", "especificacao")
    assert_equal BigDecimal("1"), decimal(row.dig("oleo", "volume_litros"))
  end

  test "extrato de frota agrupa por cliente e veiculo sem duplicar venda com multiplos itens" do
    contexto = create_cash_context
    combustivel = create_fuel
    produto = create_product(nome: "Aditivo", sku: "ADITIVO-#{unique_suffix}")
    cliente = create_customer(nome: "Cliente Frota")
    veiculo = Veiculo.create!(cliente:, placa: "ABC1D23", marca: "Ford", modelo: "Cargo")

    sale_one = create_sale(contexto:, cliente:, veiculo:, numero: "EF-#{unique_suffix}-1", total: 200, vendida_em: Time.zone.local(2026, 6, 5, 8))
    create_fuel_item(sale_one, combustivel:, quantidade: 20, total: 120)
    create_fuel_item(sale_one, combustivel:, quantidade: 5, total: 30)
    create_product_item(sale_one, produto:, quantidade: 1, total: 50)

    sale_two = create_sale(contexto:, cliente:, veiculo:, numero: "EF-#{unique_suffix}-2", total: 80, vendida_em: Time.zone.local(2026, 6, 20, 8))
    create_fuel_item(sale_two, combustivel:, quantidade: 10, total: 80)

    outside_month = create_sale(contexto:, cliente:, veiculo:, numero: "EF-#{unique_suffix}-3", total: 90, vendida_em: Time.zone.local(2026, 7, 1, 8))
    create_fuel_item(outside_month, combustivel:, quantidade: 9, total: 90)

    other_customer = create_customer(nome: "Outro Cliente")
    other_vehicle = Veiculo.create!(cliente: other_customer, placa: "XYZ9W88")
    other_sale = create_sale(contexto:, cliente: other_customer, veiculo: other_vehicle, numero: "EF-#{unique_suffix}-4", total: 300, vendida_em: Time.zone.local(2026, 6, 10, 8))
    create_fuel_item(other_sale, combustivel:, quantidade: 30, total: 300)

    get "/relatorios/extrato-frota", params: { mes: "2026-06", cliente_id: cliente.id }

    assert_response :success
    body = response.parsed_body
    assert_equal 1, body.size

    row = body.first
    assert_equal cliente.id, row.fetch("cliente_id")
    assert_equal "Cliente Frota", row.fetch("cliente_nome")
    assert_equal veiculo.id, row.fetch("veiculo_id")
    assert_equal "ABC1D23", row.fetch("veiculo_placa")
    assert_equal BigDecimal("280"), decimal(row.fetch("total_gasto"))
    assert_equal BigDecimal("35"), decimal(row.fetch("litros"))
    assert_equal 2, row.fetch("quantidade_vendas")
  end

  private

  def create_cash_context
    cargo = Cargo.create!(nome: "Operador #{unique_suffix}")
    funcionario = Funcionario.create!(cargo:, nome: "Funcionario #{unique_suffix}", cpf: unique_digits(11), data_admissao: Date.new(2026, 1, 1))
    turno = Turno.create!(nome: "Turno #{unique_suffix}", hora_inicio: "08:00", hora_fim: "16:00")
    escala = Escala.create!(funcionario:, turno:, data: Date.new(2026, 6, 10), status: "realizada")
    caixa = Caixa.create!(escala:, funcionario:, aberto_em: Time.zone.local(2026, 6, 10, 8), status: "aberto")

    { caixa:, funcionario:, turno: }
  end

  def create_sale(contexto:, numero:, total:, vendida_em:, cliente: nil, veiculo: nil)
    Venda.create!(
      caixa: contexto.fetch(:caixa),
      funcionario: contexto.fetch(:funcionario),
      cliente:,
      veiculo:,
      numero:,
      vendida_em:,
      subtotal: total,
      total:,
      status: "finalizada"
    )
  end

  def create_fuel
    Combustivel.create!(nome: "Diesel #{unique_suffix}", tipo: "diesel", codigo_anp: unique_digits(9), unidade_medida: "litro")
  end

  def create_product(nome:, sku:)
    categoria = Categoria.create!(nome: "Categoria #{unique_suffix}")
    Produto.create!(categoria:, nome:, sku:, preco_venda: 10)
  end

  def create_customer(nome:)
    cliente = Cliente.create!(tipo: "pf")
    ClientePessoaFisica.create!(cliente:, nome:, cpf: unique_digits(11))
    cliente
  end

  def create_fuel_item(sale, combustivel:, quantidade:, total:)
    VendaItem.create!(venda: sale, combustivel:, descricao: combustivel.nome, quantidade:, valor_unitario: total.to_d / quantidade.to_d, total:)
  end

  def create_product_item(sale, produto:, quantidade:, total:)
    VendaItem.create!(venda: sale, produto:, descricao: produto.nome, quantidade:, valor_unitario: total.to_d / quantidade.to_d, total:)
  end

  def unique_suffix
    SecureRandom.hex(4)
  end

  def unique_digits(length)
    SecureRandom.random_number(10**length).to_s.rjust(length, "0")
  end

  def decimal(value)
    BigDecimal(value.to_s)
  end
end
