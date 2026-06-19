class Pagamento < ApplicationRecord
  self.table_name = "pagamentos"

  FORMAS = %w[dinheiro cartao_credito cartao_debito pix voucher boleto].freeze
  STATUSES = %w[pendente aprovado recusado cancelado estornado].freeze

  belongs_to :venda
  belongs_to :caixa
  belongs_to :forma_pagamento, optional: true

  scope :aprovados, -> { where(status: "aprovado") }
  scope :pendentes, -> { where(status: "pendente") }

  validates :forma, :status, presence: true
  validates :forma, inclusion: { in: FORMAS }
  validates :status, inclusion: { in: STATUSES }
  validates :valor, numericality: { greater_than: 0 }
end
