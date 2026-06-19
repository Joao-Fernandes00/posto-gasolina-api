class LeituraEncerrante < ApplicationRecord
  self.table_name = "leituras_encerrantes"

  belongs_to :bico
  belongs_to :funcionario

  validates :lida_em, presence: true
  validates :encerrante_litros, numericality: { greater_than_or_equal_to: 0 }
  validates :lida_em, uniqueness: { scope: :bico_id }
end
