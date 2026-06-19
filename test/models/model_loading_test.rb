require "test_helper"

class ModelLoadingTest < ActiveSupport::TestCase
  test "loads all models and exposes required scopes" do
    Rails.application.eager_load!

    assert_respond_to Sale, :completed
    assert_respond_to Product, :active
    assert_respond_to Product, :critical_stock
    assert_respond_to ShiftRegister, :open
    assert_respond_to FuelPriceHistory, :current

    assert_kind_of ActiveRecord::Relation, Sale.completed
    assert_kind_of ActiveRecord::Relation, Product.active
    assert_kind_of ActiveRecord::Relation, Product.critical_stock
    assert_kind_of ActiveRecord::Relation, ShiftRegister.open
    assert_kind_of ActiveRecord::Relation, FuelPriceHistory.current
  end

  test "finds current fuel price by validity period" do
    combustivel = Combustivel.create!(nome: "Gasolina Teste", tipo: "gasolina", codigo_anp: "320102001")

    HistoricoPreco.create!(
      combustivel:,
      preco: 5.499,
      vigente_em: 2.days.ago,
      encerrado_em: 1.day.ago
    )
    vigente = HistoricoPreco.create!(
      combustivel:,
      preco: 5.899,
      vigente_em: 1.hour.ago
    )

    assert_equal vigente, combustivel.preco_vigente
    assert_equal vigente.id, FuelPriceHistory.preco_vigente_para(combustivel).id
    assert_equal BigDecimal("5.899"), combustivel.valor_preco_vigente
  end
end
