module Api
  module V1
    class BombasController < BaseCrudController
      self.model_class = Bomba
      self.permitted_attributes = %i[codigo descricao ativo]
    end
  end
end
