class Permissao < ApplicationRecord
  self.table_name = "permissoes"

  has_many :cargo_permissoes, dependent: :destroy
  has_many :cargos, through: :cargo_permissoes

  validates :chave, presence: true, uniqueness: true
  validates :nome, presence: true
end
