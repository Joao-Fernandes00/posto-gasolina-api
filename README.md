# Posto Gasolina API

API Rails para operacao de posto de combustiveis com cadastro operacional, venda transacional e relatorios.

O schema do sistema possui 40 tabelas de dominio, todas mantidas por Active Record migrations e documentadas em `docs/der.mmd`, `docs/dicionario_dados.md` e `database/ddl.sql`.

## Stack

- Ruby 3.3.8
- Rails 7.2 API
- PostgreSQL 16
- Minitest
- Docker Compose

## Como Rodar

```bash
make setup
make server
```

A API fica disponivel em `http://localhost:3000`.

## Comandos Uteis

```bash
make db-migrate
make seed
make routes
make test
make down
```

## Seeds

Os seeds sao idempotentes e criam dados para testar o fluxo completo:

- funcionarios, cargos, turnos, escala e caixa aberto;
- combustiveis, historico de precos, tanques, bombas e bicos;
- produtos, estoque e oleo lubrificante abaixo do estoque minimo;
- clientes PF/PJ, frota e veiculo diesel;
- uma venda finalizada via `SaleCreationService` com todas as formas de pagamento aceitas.
- formas de pagamento cadastradas em `formas_pagamento` e pagamentos vinculados a elas quando a chave existir.

Venda seed: `SEED-0001`.

## Rotas Principais

CRUD API v1:

- `GET|POST /api/v1/tipos_combustivel`
- `GET|POST /api/v1/tanques`
- `GET|POST /api/v1/bombas`
- `GET|POST /api/v1/bicos`
- `GET|POST /api/v1/funcionarios`
- `GET|POST /api/v1/caixas_turno`
- `GET|POST /api/v1/produtos`
- `GET|POST /api/v1/fornecedores`
- `GET|POST /api/v1/clientes`
- `GET|POST /api/v1/veiculos`
- `GET|POST /api/v1/vendas`

Cada recurso CRUD tambem possui `GET /:id`, `PATCH /:id` e `DELETE /:id`.

Relatorios:

- `GET /relatorios/vendas-turno?inicio=2026-06-01&fim=2026-06-30`
- `GET /relatorios/estoque-critico`
- `GET /relatorios/extrato-frota?mes=2026-06&cliente_id=1`

## Venda Transacional

`POST /api/v1/vendas` usa `SaleCreationService`, que:

- valida caixa aberto e funcionario responsavel;
- valida cliente e veiculo ativos;
- busca preco vigente do combustivel;
- baixa volume do tanque e estoque de produto;
- cria venda, itens e pagamentos em uma transacao;
- exige que a soma dos pagamentos seja igual ao total da venda.

## Documentacao

- OpenAPI: `docs/openapi.yaml`
- DER Mermaid: `docs/der.mmd`
- Dicionario de dados: `docs/dicionario_dados.md`
- DDL SQL: `database/ddl.sql`

`database/ddl.sql` foi gerado a partir do PostgreSQL migrado usando `pg_dump --schema-only`.

## Testes

```bash
make test
```

Se rodar fora do Docker, instale Ruby `3.3.8` e PostgreSQL acessivel pelas variaveis de `config/database.yml`.
