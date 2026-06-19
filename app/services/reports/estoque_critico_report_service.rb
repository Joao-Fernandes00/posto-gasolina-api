module Reports
  class EstoqueCriticoReportService
    def self.call(_params = {})
      new.call
    end

    def call
      Produto
        .active
        .joins(:estoque)
        .left_outer_joins(:oleo)
        .where("estoques.quantidade < estoques.quantidade_minima")
        .includes(:categoria, :estoque, :oleo)
        .order(:nome)
        .map { |product| serialize_product(product) }
    end

    private

    def serialize_product(product)
      {
        produto_id: product.id,
        nome: product.nome,
        sku: product.sku,
        categoria_id: product.categoria_id,
        categoria_nome: product.categoria.nome,
        estoque_atual: product.estoque.quantidade,
        estoque_minimo: product.estoque.quantidade_minima,
        oleo: oil_data(product.oleo)
      }
    end

    def oil_data(oil)
      return nil if oil.blank?

      {
        viscosidade: oil.viscosidade,
        especificacao: oil.especificacao,
        volume_litros: oil.volume_litros
      }
    end
  end
end
