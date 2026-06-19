module Api
  module V1
    class CaixasController < BaseCrudController
      self.model_class = Caixa
      self.permitted_attributes = %i[
        escala_id funcionario_id aberto_em fechado_em valor_inicial valor_final status
      ]
    end
  end
end
