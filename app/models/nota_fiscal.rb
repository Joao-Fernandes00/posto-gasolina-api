class NotaFiscal < ApplicationRecord
  self.table_name = "notas_fiscais"

  STATUSES = %w[emitida cancelada recebida].freeze

  belongs_to :fornecedor
  has_many :nota_fiscal_itens, class_name: "NotaFiscalItem", dependent: :destroy
  has_many :produtos, through: :nota_fiscal_itens

  scope :recebidas, -> { where(status: "recebida") }

  validates :numero, :serie, :chave_acesso, :data_emissao, :status, presence: true
  validates :chave_acesso, length: { is: 44 }, uniqueness: true
  validates :numero, uniqueness: { scope: %i[fornecedor_id serie] }
  validates :valor_total, numericality: { greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: STATUSES }
end
