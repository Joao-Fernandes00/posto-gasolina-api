class Categoria < ApplicationRecord
  self.table_name = "categorias"

  has_many :produtos, dependent: :restrict_with_exception

  scope :ativas, -> { where(ativo: true) }

  validates :nome, presence: true, uniqueness: true
end
