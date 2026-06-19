class CupomFiscal < ApplicationRecord
  self.table_name = "cupons_fiscais"

  STATUSES = %w[emitido cancelado].freeze

  belongs_to :venda

  validates :numero, :serie, :chave_acesso, :emitido_em, :status, presence: true
  validates :venda_id, uniqueness: true
  validates :chave_acesso, length: { is: 44 }, uniqueness: true
  validates :numero, uniqueness: { scope: :serie }
  validates :valor_total, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
end
