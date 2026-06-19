class ClientePessoaJuridica < ApplicationRecord
  self.table_name = "cliente_pessoas_juridicas"

  belongs_to :cliente

  validates :razao_social, :cnpj, presence: true
  validates :cliente_id, uniqueness: true
  validates :cnpj, length: { is: 14 }, uniqueness: true
end
