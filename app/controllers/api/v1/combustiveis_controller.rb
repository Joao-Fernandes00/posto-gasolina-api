module Api
  module V1
    class CombustiveisController < BaseCrudController
      self.model_class = Combustivel
      self.permitted_attributes = %i[nome tipo codigo_anp unidade_medida ativo]
    end
  end
end
