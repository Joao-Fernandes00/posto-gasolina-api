class Escala < ApplicationRecord
  self.table_name = "escalas"

  STATUSES = %w[prevista realizada cancelada].freeze

  belongs_to :funcionario
  belongs_to :turno
  has_one :caixa, dependent: :restrict_with_exception

  scope :previstas, -> { where(status: "prevista") }
  scope :realizadas, -> { where(status: "realizada") }

  validates :data, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :funcionario_id, uniqueness: { scope: %i[turno_id data] }
end
