class ClientePessoaFisica < ApplicationRecord
  self.table_name = "cliente_pessoas_fisicas"

  belongs_to :cliente

  validates :nome, :cpf, presence: true
  validates :cliente_id, uniqueness: true
  validates :cpf, length: { is: 11 }, uniqueness: true
end
