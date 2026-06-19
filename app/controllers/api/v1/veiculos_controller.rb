module Api
  module V1
    class VeiculosController < BaseCrudController
      self.model_class = Veiculo
      self.permitted_attributes = %i[cliente_id frota_id placa marca modelo ano cor tipo ativo]
    end
  end
end
