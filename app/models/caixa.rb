class Caixa < ApplicationRecord
  self.table_name = "caixas"

  STATUSES = %w[aberto fechado cancelado].freeze

  belongs_to :escala
  belongs_to :funcionario
  has_one :fechamento_caixa, dependent: :restrict_with_exception
  has_many :vendas, dependent: :restrict_with_exception
  has_many :pagamentos, dependent: :restrict_with_exception

  scope :fechados, -> { where(status: "fechado") }

  def self.open
    where(status: "aberto")
  end

  validates :aberto_em, :status, presence: true
  validates :escala_id, uniqueness: true
  validates :status, inclusion: { in: STATUSES }
  validates :valor_inicial, numericality: { greater_than_or_equal_to: 0 }
  validates :valor_final, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :fechado_em_nao_antecede_abertura

  private

  def fechado_em_nao_antecede_abertura
    return if fechado_em.blank? || aberto_em.blank? || fechado_em >= aberto_em

    errors.add(:fechado_em, "deve ser maior ou igual a abertura")
  end
end
