class ContaReceber < ApplicationRecord
  self.table_name = "contas_receber"

  STATUSES = %w[aberta paga vencida cancelada].freeze

  belongs_to :cliente
  belongs_to :venda
  has_many :parcelas_receber, dependent: :destroy

  validates :numero, :vencimento_em, :status, presence: true
  validates :numero, uniqueness: true
  validates :venda_id, uniqueness: true
  validates :valor_total, :saldo, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
  validate :saldo_nao_excede_valor_total

  private

  def saldo_nao_excede_valor_total
    return if saldo.blank? || valor_total.blank? || saldo <= valor_total

    errors.add(:saldo, "nao pode exceder o valor total")
  end
end
