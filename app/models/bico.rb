class Bico < ApplicationRecord
  self.table_name = "bicos"

  belongs_to :bomba
  belongs_to :tanque
  has_one :combustivel, through: :tanque
  has_many :manutencoes, dependent: :restrict_with_exception
  has_many :afericoes, dependent: :restrict_with_exception
  has_many :venda_itens, dependent: :restrict_with_exception

  scope :ativos, -> { where(ativo: true) }

  validates :numero, numericality: { only_integer: true, greater_than: 0 }
  validates :codigo, presence: true, uniqueness: true
  validates :encerrante_litros, numericality: { greater_than_or_equal_to: 0 }
  validates :numero, uniqueness: { scope: :bomba_id }
end
