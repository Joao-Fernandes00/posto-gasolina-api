class Estoque < ApplicationRecord
  self.table_name = "estoques"

  belongs_to :produto

  scope :criticos, -> { where("quantidade <= quantidade_minima") }

  validates :produto_id, uniqueness: true
  validates :quantidade, :quantidade_minima, numericality: { greater_than_or_equal_to: 0 }
end
