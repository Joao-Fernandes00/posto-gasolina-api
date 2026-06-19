class MovimentacaoTanque < ApplicationRecord
  self.table_name = "movimentacao_tanques"

  TIPOS = %w[entrada saida ajuste].freeze

  belongs_to :tanque
  belongs_to :combustivel
  belongs_to :venda_item, optional: true

  validates :tipo, :movimentada_em, presence: true
  validates :tipo, inclusion: { in: TIPOS }
  validates :volume_litros, numericality: { other_than: 0 }
  validates :saldo_apos_litros, numericality: { greater_than_or_equal_to: 0 }
end
