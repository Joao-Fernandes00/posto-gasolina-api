class Combustivel < ApplicationRecord
  self.table_name = "combustiveis"

  has_many :historico_precos, dependent: :destroy
  has_many :tanques, dependent: :restrict_with_exception
  has_many :venda_itens, dependent: :restrict_with_exception

  scope :ativos, -> { where(ativo: true) }

  validates :nome, :tipo, :codigo_anp, :unidade_medida, presence: true
  validates :nome, :codigo_anp, uniqueness: true

  def preco_vigente(em: Time.current)
    historico_precos.current(em).order(vigente_em: :desc).first
  end

  def valor_preco_vigente(em: Time.current)
    preco_vigente(em:)&.preco
  end
end
