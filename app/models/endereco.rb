class Endereco < ApplicationRecord
  self.table_name = "enderecos"

  has_many :funcionarios, dependent: :restrict_with_exception
  has_many :fornecedores, dependent: :restrict_with_exception
  has_many :clientes, dependent: :restrict_with_exception

  validates :logradouro, :numero, :bairro, :cidade, :estado, :cep, presence: true
  validates :estado, length: { is: 2 }
  validates :cep, length: { is: 8 }
end
