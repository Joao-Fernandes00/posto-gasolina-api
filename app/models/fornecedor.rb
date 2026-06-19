class Fornecedor < ApplicationRecord
  self.table_name = "fornecedores"

  belongs_to :endereco, optional: true
  has_many :notas_fiscais, dependent: :restrict_with_exception

  scope :ativos, -> { where(ativo: true) }

  validates :razao_social, :cnpj, presence: true
  validates :cnpj, length: { is: 14 }, uniqueness: true
end
