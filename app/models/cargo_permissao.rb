class CargoPermissao < ApplicationRecord
  self.table_name = "cargo_permissoes"

  belongs_to :cargo
  belongs_to :permissao

  validates :permissao_id, uniqueness: { scope: :cargo_id }
end
