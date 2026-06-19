class HistoricoPreco < ApplicationRecord
  self.table_name = "historico_precos"

  belongs_to :combustivel

  scope :current, lambda { |moment = Time.current|
    where("vigente_em <= ?", moment).where("encerrado_em IS NULL OR encerrado_em > ?", moment)
  }

  validates :preco, :vigente_em, presence: true
  validates :preco, numericality: { greater_than: 0 }
  validates :vigente_em, uniqueness: { scope: :combustivel_id }
  validate :encerrado_em_posterior_ao_inicio

  def self.preco_vigente_para(combustivel, em: Time.current)
    where(combustivel:).current(em).order(vigente_em: :desc).first
  end

  private

  def encerrado_em_posterior_ao_inicio
    return if encerrado_em.blank? || vigente_em.blank? || encerrado_em > vigente_em

    errors.add(:encerrado_em, "deve ser posterior ao inicio da vigencia")
  end
end
