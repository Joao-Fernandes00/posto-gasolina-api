class Oleo < ApplicationRecord
  self.table_name = "oleos"

  belongs_to :produto

  validates :produto_id, uniqueness: true
  validates :viscosidade, presence: true
  validates :volume_litros, numericality: { greater_than: 0 }
end
