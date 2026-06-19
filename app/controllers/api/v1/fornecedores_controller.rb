module Api
  module V1
    class FornecedoresController < BaseCrudController
      self.model_class = Fornecedor
      self.permitted_attributes = %i[
        endereco_id razao_social nome_fantasia cnpj inscricao_estadual email telefone ativo
      ]
    end
  end
end
