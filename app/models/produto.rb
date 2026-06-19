class Produto < ApplicationRecord
  self.table_name = "produtos"

  belongs_to :categoria
  has_one :oleo, dependent: :destroy
  has_one :estoque, dependent: :destroy
  has_many :nota_fiscal_itens, class_name: "NotaFiscalItem", dependent: :restrict_with_exception
  has_many :notas_fiscais, through: :nota_fiscal_itens
  has_many :venda_itens, class_name: "VendaItem", dependent: :restrict_with_exception
  has_many :vendas, through: :venda_itens
  has_many :movimentacao_estoques, dependent: :restrict_with_exception

  scope :active, -> { where(ativo: true) }
  scope :critical_stock, -> { joins(:estoque).where("estoques.quantidade <= estoques.quantidade_minima") }

  validates :nome, :sku, :unidade_medida, presence: true
  validates :sku, uniqueness: true
  validates :codigo_barras, uniqueness: true, allow_blank: true
  validates :preco_venda, :custo_medio, numericality: { greater_than_or_equal_to: 0 }
end
