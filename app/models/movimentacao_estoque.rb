class MovimentacaoEstoque < ApplicationRecord
  self.table_name = "movimentacao_estoques"

  TIPOS = %w[entrada saida ajuste].freeze

  belongs_to :produto
  belongs_to :funcionario, optional: true

  validates :tipo, :movimentada_em, presence: true
  validates :tipo, inclusion: { in: TIPOS }
  validates :quantidade, numericality: { other_than: 0 }
  validates :saldo_apos, numericality: { greater_than_or_equal_to: 0 }
end
