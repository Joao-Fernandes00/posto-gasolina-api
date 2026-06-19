class VendaItem < ApplicationRecord
  self.table_name = "venda_itens"

  belongs_to :venda
  belongs_to :produto, optional: true
  belongs_to :combustivel, optional: true
  belongs_to :bico, optional: true
  has_many :movimentacao_tanques, dependent: :restrict_with_exception

  validates :descricao, presence: true
  validates :quantidade, numericality: { greater_than: 0 }
  validates :valor_unitario, :desconto, :total, numericality: { greater_than_or_equal_to: 0 }
  validate :produto_ou_combustivel
  validate :bico_apenas_para_combustivel

  private

  def produto_ou_combustivel
    return if produto_id.present? ^ combustivel_id.present?

    errors.add(:base, "informe produto ou combustivel")
  end

  def bico_apenas_para_combustivel
    return if bico_id.blank? || combustivel_id.present?

    errors.add(:bico, "so pode ser informado para combustivel")
  end
end
