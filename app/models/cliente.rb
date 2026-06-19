class Cliente < ApplicationRecord
  self.table_name = "clientes"

  TIPOS = %w[pf pj].freeze

  belongs_to :endereco, optional: true
  has_one :pessoa_fisica, class_name: "ClientePessoaFisica", dependent: :destroy
  has_one :pessoa_juridica, class_name: "ClientePessoaJuridica", dependent: :destroy
  has_many :frotas, dependent: :restrict_with_exception
  has_many :veiculos, dependent: :restrict_with_exception
  has_many :vendas, dependent: :restrict_with_exception

  scope :ativos, -> { where(ativo: true) }
  scope :pessoas_fisicas, -> { where(tipo: "pf") }
  scope :pessoas_juridicas, -> { where(tipo: "pj") }

  validates :tipo, presence: true, inclusion: { in: TIPOS }
end
