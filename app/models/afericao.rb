class Afericao < ApplicationRecord
  self.table_name = "afericoes"

  belongs_to :bico
  belongs_to :funcionario

  validates :realizada_em, presence: true
  validates :volume_indicado_litros, :volume_aferido_litros, numericality: { greater_than_or_equal_to: 0 }
  validates :diferenca_litros, numericality: true
end
