class ParcelaReceber < ApplicationRecord
  self.table_name = "parcelas_receber"

  STATUSES = %w[aberta paga vencida cancelada].freeze

  belongs_to :conta_receber

  validates :numero, :vencimento_em, :status, presence: true
  validates :numero, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :conta_receber_id }
  validates :valor, numericality: { greater_than: 0 }
  validates :saldo, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validate :saldo_nao_excede_valor

  private

  def saldo_nao_excede_valor
    return if saldo.blank? || valor.blank? || saldo <= valor

    errors.add(:saldo, "nao pode exceder o valor")
  end
end
