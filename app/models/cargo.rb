class Cargo < ApplicationRecord
  self.table_name = "cargos"

  has_many :cargo_permissoes, dependent: :destroy
  has_many :permissoes, through: :cargo_permissoes
  has_many :funcionarios, dependent: :restrict_with_exception

  scope :ativos, -> { where(ativo: true) }

  validates :nome, presence: true, uniqueness: true
end
