class Bomba < ApplicationRecord
  self.table_name = "bombas"

  has_many :bicos, dependent: :restrict_with_exception
  has_many :tanques, through: :bicos
  has_many :manutencoes, dependent: :restrict_with_exception

  scope :ativas, -> { where(ativo: true) }

  validates :codigo, presence: true, uniqueness: true
end
