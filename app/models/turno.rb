class Turno < ApplicationRecord
  self.table_name = "turnos"

  has_many :escalas, dependent: :restrict_with_exception
  has_many :funcionarios, through: :escalas

  scope :ativos, -> { where(ativo: true) }

  validates :nome, :hora_inicio, :hora_fim, presence: true
  validates :nome, uniqueness: true
end
