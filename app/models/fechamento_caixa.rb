class FechamentoCaixa < ApplicationRecord
  self.table_name = "fechamento_caixas"

  belongs_to :caixa
  belongs_to :funcionario

  validates :caixa_id, uniqueness: true
  validates :fechado_em, presence: true
  validates :valor_informado, :valor_sistema, numericality: { greater_than_or_equal_to: 0 }
  validates :diferenca, numericality: true
end
