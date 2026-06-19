class AuditoriaEvento < ApplicationRecord
  self.table_name = "auditoria_eventos"

  ACOES = %w[criado atualizado removido login logout erro].freeze

  belongs_to :funcionario, optional: true

  validates :entidade, :acao, :ocorrido_em, presence: true
  validates :acao, inclusion: { in: ACOES }
end
