class CalibracaoBico < ApplicationRecord
  self.table_name = "calibracoes_bicos"

  STATUSES = %w[aprovada reprovada].freeze

  belongs_to :bico
  belongs_to :funcionario

  validates :realizada_em, :status, presence: true
  validates :realizada_em, uniqueness: { scope: :bico_id }
  validates :vazao_litros_minuto, numericality: { greater_than: 0 }
  validates :desvio_percentual, numericality: true
  validates :status, inclusion: { in: STATUSES }
end
