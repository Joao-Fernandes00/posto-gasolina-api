class Frota < ApplicationRecord
  self.table_name = "frotas"

  belongs_to :cliente
  has_many :veiculos, dependent: :restrict_with_exception

  scope :ativas, -> { where(ativo: true) }

  validates :nome, :codigo, presence: true
  validates :codigo, uniqueness: { scope: :cliente_id }
end
