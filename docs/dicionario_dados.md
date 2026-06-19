# Dicionario de Dados

## Operacao

| Tabela | Descricao | Chaves e regras principais |
| --- | --- | --- |
| `enderecos` | Enderecos de clientes, fornecedores e funcionarios. | `cep` com 8 caracteres, `estado` com 2 caracteres. |
| `cargos` | Cargos dos funcionarios. | `nome` unico. |
| `permissoes` | Permissoes funcionais. | `chave` unica. |
| `cargo_permissoes` | Associacao N:N entre cargos e permissoes. | Unico por `cargo_id` e `permissao_id`. |
| `funcionarios` | Funcionarios do posto. | `cpf` unico com 11 caracteres, salario nao negativo. |
| `turnos` | Turnos de trabalho. | `nome` unico. |
| `escalas` | Escalas por funcionario, turno e data. | Unico por `funcionario_id`, `turno_id` e `data`. |
| `caixas` | Caixa aberto, fechado ou cancelado por escala. | `escala_id` unico, valores nao negativos. |
| `fechamento_caixas` | Conferencia de fechamento de caixa. | Um fechamento por caixa; valores informados e de sistema nao negativos. |
| `auditoria_eventos` | Trilha de auditoria operacional. | Acao limitada a `criado`, `atualizado`, `removido`, `login`, `logout` ou `erro`. |

## Abastecimento

| Tabela | Descricao | Chaves e regras principais |
| --- | --- | --- |
| `combustiveis` | Tipos de combustivel comercializados. | `nome` e `codigo_anp` unicos. |
| `historico_precos` | Precos vigentes por combustivel. | Unico por `combustivel_id` e `vigente_em`; preco maior que zero. |
| `tanques` | Tanques fisicos por combustivel. | `codigo` unico; volume atual entre zero e capacidade. |
| `bombas` | Bombas de abastecimento. | `codigo` unico. |
| `bicos` | Bicos vinculados a bomba e tanque. | `codigo` unico; `numero` unico por bomba. |
| `leituras_encerrantes` | Leituras historicas de encerrante por bico. | Unico por `bico_id` e `lida_em`; encerrante nao negativo. |
| `calibracoes_bicos` | Calibracoes de vazao dos bicos. | Unico por `bico_id` e `realizada_em`; vazao maior que zero. |
| `movimentacao_tanques` | Entradas, saidas e ajustes de volume dos tanques. | Tipo limitado a `entrada`, `saida` ou `ajuste`; saldo nao negativo. |
| `manutencoes` | Manutencoes de tanque, bomba ou bico. | Exige exatamente um equipamento informado. |
| `afericoes` | Afericoes de bicos. | Volumes nao negativos. |

## Produtos e Compras

| Tabela | Descricao | Chaves e regras principais |
| --- | --- | --- |
| `categorias` | Categorias de produtos. | `nome` unico. |
| `produtos` | Produtos vendidos na loja. | `sku` unico, preco e custo nao negativos. |
| `oleos` | Dados especificos de oleos lubrificantes. | Um registro por produto; `volume_litros` maior que zero. |
| `estoques` | Estoque por produto. | Um registro por produto; quantidades nao negativas. |
| `movimentacao_estoques` | Entradas, saidas e ajustes de estoque. | Tipo limitado a `entrada`, `saida` ou `ajuste`; saldo nao negativo. |
| `fornecedores` | Fornecedores de produtos. | `cnpj` unico com 14 caracteres. |
| `notas_fiscais` | Notas fiscais de compra. | `chave_acesso` unica com 44 caracteres. |
| `nota_fiscal_itens` | Itens das notas fiscais. | Quantidade maior que zero, valores nao negativos. |

## Clientes, Frota e Vendas

| Tabela | Descricao | Chaves e regras principais |
| --- | --- | --- |
| `clientes` | Clientes PF ou PJ. | `tipo` limitado a `pf` ou `pj`. |
| `cliente_pessoas_fisicas` | Dados de cliente PF. | Um registro por cliente; `cpf` unico. |
| `cliente_pessoas_juridicas` | Dados de cliente PJ. | Um registro por cliente; `cnpj` unico. |
| `frotas` | Frotas de clientes PJ ou PF. | `codigo` unico por cliente. |
| `veiculos` | Veiculos de clientes ou frotas. | `placa` unica; exige cliente ou frota. |
| `vendas` | Vendas do caixa. | `numero` unico; status `aberta`, `finalizada` ou `cancelada`. |
| `cupons_fiscais` | Cupom fiscal emitido para venda. | Um cupom por venda; chave de acesso unica com 44 caracteres. |
| `contas_receber` | Contas financeiras geradas por vendas a prazo. | Uma conta por venda; saldo entre zero e valor total. |
| `parcelas_receber` | Parcelas de contas a receber. | Numero unico por conta; saldo entre zero e valor da parcela. |
| `venda_itens` | Itens de produto ou combustivel em uma venda. | Exige produto ou combustivel, nunca ambos. |
| `formas_pagamento` | Cadastro das formas de pagamento aceitas. | `chave` unica. |
| `pagamentos` | Pagamentos da venda. | Forma limitada a `dinheiro`, `cartao_credito`, `cartao_debito`, `pix`, `voucher` ou `boleto`. |

## Relatorios

| Relatorio | Fonte | Observacao |
| --- | --- | --- |
| Vendas por turno | `vendas`, `caixas`, `escalas`, `turnos`, `venda_itens` | Agrega totais financeiros por venda separadamente dos litros para evitar duplicacao por joins. |
| Estoque critico | `produtos`, `estoques`, `oleos` | Retorna produtos ativos com estoque atual menor que estoque minimo. |
| Extrato de frota | `vendas`, `venda_itens`, `clientes`, `veiculos` | Agrega por cliente e veiculo no mes informado. |
