module Api
  module V1
    class ClientesController < BaseCrudController
      self.model_class = Cliente
      self.permitted_attributes = %i[endereco_id tipo email telefone ativo]
    end
  end
end
