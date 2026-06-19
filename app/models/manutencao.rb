class Manutencao < ApplicationRecord
  self.table_name = "manutencoes"

  STATUSES = %w[aberta concluida cancelada].freeze

  belongs_to :tanque, optional: true
  belongs_to :bomba, optional: true
  belongs_to :bico, optional: true

  scope :abertas, -> { where(status: "aberta") }
  scope :concluidas, -> { where(status: "concluida") }

  validates :tipo, :descricao, :iniciada_em, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :custo, numericality: { greater_than_or_equal_to: 0 }
  validate :apenas_um_equipamento
  validate :finalizada_em_nao_antecede_inicio

  private

  def apenas_um_equipamento
    return if [ tanque_id, bomba_id, bico_id ].compact.one?

    errors.add(:base, "informe exatamente um equipamento")
  end

  def finalizada_em_nao_antecede_inicio
    return if finalizada_em.blank? || iniciada_em.blank? || finalizada_em >= iniciada_em

    errors.add(:finalizada_em, "deve ser maior ou igual ao inicio")
  end
end
