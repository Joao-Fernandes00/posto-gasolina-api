module Api
  module V1
    class ProdutosController < BaseCrudController
      self.model_class = Produto
      self.permitted_attributes = %i[
        categoria_id nome sku codigo_barras unidade_medida preco_venda custo_medio ativo
      ]
    end
  end
end
