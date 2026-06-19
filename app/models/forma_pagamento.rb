class FormaPagamento < ApplicationRecord
  self.table_name = "formas_pagamento"

  has_many :pagamentos, dependent: :restrict_with_exception

  scope :ativas, -> { where(ativo: true) }

  validates :chave, :nome, presence: true
  validates :chave, uniqueness: true
end
