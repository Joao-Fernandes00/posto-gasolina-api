class Veiculo < ApplicationRecord
  self.table_name = "veiculos"

  belongs_to :cliente, optional: true
  belongs_to :frota, optional: true
  has_many :vendas, dependent: :restrict_with_exception

  scope :ativos, -> { where(ativo: true) }

  validates :placa, presence: true, length: { is: 7 }, uniqueness: true
  validates :ano, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: 2100 }, allow_nil: true
  validate :cliente_ou_frota_presente

  private

  def cliente_ou_frota_presente
    return if cliente_id.present? || frota_id.present?

    errors.add(:base, "informe cliente ou frota")
  end
end
