module Api
  module V1
    class TanquesController < BaseCrudController
      self.model_class = Tanque
      self.permitted_attributes = %i[combustivel_id codigo capacidade_litros volume_atual_litros ativo]
    end
  end
end
