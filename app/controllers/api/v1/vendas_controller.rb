module Api
  module V1
    class VendasController < BaseCrudController
      self.model_class = Venda
      self.permitted_attributes = %i[
        cliente_id funcionario_id caixa_id veiculo_id numero vendida_em subtotal desconto total status
      ]
    end
  end
end
