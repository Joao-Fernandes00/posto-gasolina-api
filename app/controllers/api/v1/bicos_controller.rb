module Api
  module V1
    class BicosController < BaseCrudController
      self.model_class = Bico
      self.permitted_attributes = %i[bomba_id tanque_id numero codigo encerrante_litros ativo]
    end
  end
end
