require "test_helper"

class SaleCreationServiceTest < ActiveSupport::TestCase
  setup do
    @cargo = Cargo.create!(nome: "Operador")
    @employee = Funcionario.create!(cargo: @cargo, nome: "Funcionario", cpf: "12345678901", data_admissao: Date.current)
    @other_employee = Funcionario.create!(cargo: @cargo, nome: "Outro", cpf: "12345678902", data_admissao: Date.current)
    @turno = Turno.create!(nome: "Manha", hora_inicio: "08:00", hora_fim: "14:00")
    @escala = Escala.create!(funcionario: @employee, turno: @turno, data: Date.current)
    @caixa = Caixa.create!(escala: @escala, funcionario: @employee, aberto_em: Time.current, valor_inicial: 100)

    @fuel = Combustivel.create!(nome: "Gasolina Comum", tipo: "gasolina", codigo_anp: "320102001")
    HistoricoPreco.create!(combustivel: @fuel, preco: "5.899", vigente_em: 1.hour.ago)
    @tank = Tanque.create!(combustivel: @fuel, codigo: "TQ-01", capacidade_litros: 1000, volume_atual_litros: 100)
    @pump = Bomba.create!(codigo: "B-01")
    @nozzle = Bico.create!(bomba: @pump, tanque: @tank, numero: 1, codigo: "B-01-01", encerrante_litros: 1000)

    @category = Categoria.create!(nome: "Loja")
    @product = Produto.create!(categoria: @category, nome: "Oleo 20W50", sku: "OL-20W50", preco_venda: 10, custo_medio: 7)
    @stock = Estoque.create!(produto: @product, quantidade: 10, quantidade_minima: 2)

    @customer = Cliente.create!(tipo: "pf")
    @vehicle = Veiculo.create!(cliente: @customer, placa: "ABC1D23", tipo: "gasolina")
  end

  test "creates completed sale and updates tank, nozzle and stock" do
    sale = nil

    assert_difference -> { Venda.count }, 1 do
      assert_difference -> { VendaItem.count }, 2 do
        assert_difference -> { Pagamento.count }, 2 do
          sale = SaleCreationService.call(valid_params)
        end
      end
    end

    assert_equal "finalizada", sale.status
    assert_equal BigDecimal("78.99"), sale.total
    assert_equal BigDecimal("90.0"), @tank.reload.volume_atual_litros
    assert_equal BigDecimal("1010.0"), @nozzle.reload.encerrante_litros
    assert_equal BigDecimal("8.0"), @stock.reload.quantidade
  end

  test "requires open cash register" do
    @caixa.update!(status: "fechado", fechado_em: Time.current, valor_final: 100)

    error = assert_raises(SaleCreationService::Error) do
      SaleCreationService.call(valid_params)
    end

    assert_equal "caixa deve estar aberto", error.message
  end

  test "requires sale employee to be cash register employee" do
    params = valid_params.merge(funcionario_id: @other_employee.id)

    error = assert_raises(SaleCreationService::Error) do
      SaleCreationService.call(params)
    end

    assert_equal "funcionario deve ser o responsavel pelo caixa", error.message
  end

  test "rolls back fuel decrease when product stock is insufficient" do
    @stock.update!(quantidade: 1)

    assert_no_difference -> { Venda.count } do
      assert_no_changes -> { @tank.reload.volume_atual_litros } do
        assert_no_changes -> { @nozzle.reload.encerrante_litros } do
          assert_raises(SaleCreationService::Error) do
            SaleCreationService.call(valid_params)
          end
        end
      end
    end
  end

  test "requires payment sum to match total and rolls back decreases" do
    params = valid_params.merge(pagamentos: [ { forma: "dinheiro", valor: "1.00" } ])

    assert_no_difference -> { Venda.count } do
      assert_no_changes -> { @tank.reload.volume_atual_litros } do
        assert_no_changes -> { @stock.reload.quantidade } do
          error = assert_raises(SaleCreationService::Error) do
            SaleCreationService.call(params)
          end

          assert_equal "soma dos pagamentos deve ser igual ao total da venda", error.message
        end
      end
    end
  end

  test "rejects unauthorized vehicle fuel" do
    @vehicle.update!(tipo: "diesel")

    error = assert_raises(SaleCreationService::Error) do
      SaleCreationService.call(valid_params)
    end

    assert_equal "combustivel nao autorizado para o veiculo", error.message
  end

  private

  def valid_params
    {
      caixa_id: @caixa.id,
      funcionario_id: @employee.id,
      cliente_id: @customer.id,
      veiculo_id: @vehicle.id,
      numero: "VENDA-#{SecureRandom.hex(6)}",
      itens: [
        { bico_id: @nozzle.id, quantidade: "10.000" },
        { produto_id: @product.id, quantidade: "2.000" }
      ],
      pagamentos: [
        { forma: "dinheiro", valor: "58.99" },
        { forma: "pix", valor: "20.00" }
      ]
    }
  end
end
