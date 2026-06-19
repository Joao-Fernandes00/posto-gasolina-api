class NotaFiscalItem < ApplicationRecord
  self.table_name = "nota_fiscal_itens"

  belongs_to :nota_fiscal
  belongs_to :produto

  validates :quantidade, numericality: { greater_than: 0 }
  validates :valor_unitario, :valor_total, numericality: { greater_than_or_equal_to: 0 }
end
