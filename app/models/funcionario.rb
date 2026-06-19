class Funcionario < ApplicationRecord
  self.table_name = "funcionarios"

  belongs_to :endereco, optional: true
  belongs_to :cargo
  has_many :afericoes, dependent: :restrict_with_exception
  has_many :escalas, dependent: :restrict_with_exception
  has_many :caixas, dependent: :restrict_with_exception
  has_many :fechamento_caixas, dependent: :restrict_with_exception
  has_many :movimentacao_estoques, dependent: :nullify
  has_many :leituras_encerrantes, dependent: :restrict_with_exception
  has_many :calibracoes_bicos, dependent: :restrict_with_exception
  has_many :auditoria_eventos, dependent: :nullify
  has_many :vendas, dependent: :restrict_with_exception

  scope :ativos, -> { where(ativo: true) }

  validates :nome, :cpf, :data_admissao, presence: true
  validates :cpf, length: { is: 11 }, uniqueness: true
  validates :email, uniqueness: true, allow_blank: true
  validates :salario, numericality: { greater_than_or_equal_to: 0 }
  validate :data_demissao_nao_antecede_admissao

  private

  def data_demissao_nao_antecede_admissao
    return if data_demissao.blank? || data_admissao.blank? || data_demissao >= data_admissao

    errors.add(:data_demissao, "deve ser maior ou igual a data de admissao")
  end
end
