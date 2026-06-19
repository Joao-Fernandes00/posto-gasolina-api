class Venda < ApplicationRecord
  self.table_name = "vendas"

  STATUSES = %w[aberta finalizada cancelada].freeze

  belongs_to :cliente, optional: true
  belongs_to :funcionario
  belongs_to :caixa
  belongs_to :veiculo, optional: true
  has_many :venda_itens, class_name: "VendaItem", dependent: :destroy
  has_many :pagamentos, dependent: :restrict_with_exception
  has_many :produtos, through: :venda_itens
  has_many :combustiveis, through: :venda_itens

  scope :completed, -> { where(status: "finalizada") }
  scope :abertas, -> { where(status: "aberta") }
  scope :canceladas, -> { where(status: "cancelada") }

  validates :numero, :vendida_em, :status, presence: true
  validates :numero, uniqueness: true
  validates :status, inclusion: { in: STATUSES }
  validates :subtotal, :desconto, :total, numericality: { greater_than_or_equal_to: 0 }
  validate :desconto_nao_excede_subtotal

  private

  def desconto_nao_excede_subtotal
    return if desconto.blank? || subtotal.blank? || desconto <= subtotal

    errors.add(:desconto, "nao pode exceder o subtotal")
  end
end
