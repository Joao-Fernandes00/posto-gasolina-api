module Api
  module V1
    class FuncionariosController < BaseCrudController
      self.model_class = Funcionario
      self.permitted_attributes = %i[
        endereco_id cargo_id nome cpf email telefone data_admissao data_demissao salario ativo
      ]
    end
  end
end
