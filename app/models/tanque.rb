class Tanque < ApplicationRecord
  self.table_name = "tanques"

  belongs_to :combustivel
  has_many :bicos, dependent: :restrict_with_exception
  has_many :bombas, through: :bicos
  has_many :manutencoes, dependent: :restrict_with_exception
  has_many :movimentacao_tanques, dependent: :restrict_with_exception

  scope :ativos, -> { where(ativo: true) }

  validates :codigo, presence: true, uniqueness: true
  validates :capacidade_litros, numericality: { greater_than: 0 }
  validates :volume_atual_litros, numericality: { greater_than_or_equal_to: 0 }
  validate :volume_atual_nao_excede_capacidade

  private

  def volume_atual_nao_excede_capacidade
    return if volume_atual_litros.blank? || capacidade_litros.blank? || volume_atual_litros <= capacidade_litros

    errors.add(:volume_atual_litros, "nao pode exceder a capacidade")
  end
end
