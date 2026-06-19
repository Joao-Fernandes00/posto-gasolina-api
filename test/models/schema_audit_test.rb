require "test_helper"

class SchemaAuditTest < ActiveSupport::TestCase
  EXPECTED_TABLES = %w[
    afericoes auditoria_eventos bicos bombas caixas calibracoes_bicos cargo_permissoes cargos categorias
    cliente_pessoas_fisicas cliente_pessoas_juridicas clientes combustiveis contas_receber cupons_fiscais
    enderecos escalas estoques fechamento_caixas formas_pagamento fornecedores frotas funcionarios
    historico_precos leituras_encerrantes manutencoes movimentacao_estoques movimentacao_tanques nota_fiscal_itens
    notas_fiscais oleos pagamentos parcelas_receber permissoes produtos tanques turnos veiculos venda_itens vendas
  ].sort.freeze

  TABLE_MODELS = {
    "afericoes" => Afericao,
    "auditoria_eventos" => AuditoriaEvento,
    "bicos" => Bico,
    "bombas" => Bomba,
    "caixas" => Caixa,
    "calibracoes_bicos" => CalibracaoBico,
    "cargo_permissoes" => CargoPermissao,
    "cargos" => Cargo,
    "categorias" => Categoria,
    "cliente_pessoas_fisicas" => ClientePessoaFisica,
    "cliente_pessoas_juridicas" => ClientePessoaJuridica,
    "clientes" => Cliente,
    "combustiveis" => Combustivel,
    "contas_receber" => ContaReceber,
    "cupons_fiscais" => CupomFiscal,
    "enderecos" => Endereco,
    "escalas" => Escala,
    "estoques" => Estoque,
    "fechamento_caixas" => FechamentoCaixa,
    "formas_pagamento" => FormaPagamento,
    "fornecedores" => Fornecedor,
    "frotas" => Frota,
    "funcionarios" => Funcionario,
    "historico_precos" => HistoricoPreco,
    "leituras_encerrantes" => LeituraEncerrante,
    "manutencoes" => Manutencao,
    "movimentacao_estoques" => MovimentacaoEstoque,
    "movimentacao_tanques" => MovimentacaoTanque,
    "nota_fiscal_itens" => NotaFiscalItem,
    "notas_fiscais" => NotaFiscal,
    "oleos" => Oleo,
    "pagamentos" => Pagamento,
    "parcelas_receber" => ParcelaReceber,
    "permissoes" => Permissao,
    "produtos" => Produto,
    "tanques" => Tanque,
    "turnos" => Turno,
    "veiculos" => Veiculo,
    "venda_itens" => VendaItem,
    "vendas" => Venda
  }.freeze

  test "schema has exactly the expected 40 domain tables" do
    tables = ActiveRecord::Base.connection.tables - %w[schema_migrations ar_internal_metadata]

    assert_equal 40, tables.size
    assert_equal EXPECTED_TABLES, tables.sort
  end

  test "each domain table has a canonical active record model" do
    TABLE_MODELS.each do |table, model|
      assert_equal table, model.table_name
      assert model < ApplicationRecord
    end
  end
end
