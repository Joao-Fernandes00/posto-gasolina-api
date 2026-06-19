# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_06_19_030000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "afericoes", force: :cascade do |t|
    t.bigint "bico_id", null: false
    t.bigint "funcionario_id", null: false
    t.datetime "realizada_em", null: false
    t.decimal "volume_indicado_litros", precision: 10, scale: 3, null: false
    t.decimal "volume_aferido_litros", precision: 10, scale: 3, null: false
    t.decimal "diferenca_litros", precision: 10, scale: 3, null: false
    t.text "observacoes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bico_id", "realizada_em"], name: "index_afericoes_on_bico_id_and_realizada_em"
    t.index ["bico_id"], name: "index_afericoes_on_bico_id"
    t.index ["funcionario_id"], name: "index_afericoes_on_funcionario_id"
    t.check_constraint "volume_aferido_litros >= 0::numeric", name: "chk_afericoes_volume_aferido"
    t.check_constraint "volume_indicado_litros >= 0::numeric", name: "chk_afericoes_volume_indicado"
  end

  create_table "bicos", force: :cascade do |t|
    t.bigint "bomba_id", null: false
    t.bigint "tanque_id", null: false
    t.integer "numero", null: false
    t.string "codigo", null: false
    t.decimal "encerrante_litros", precision: 14, scale: 3, default: "0.0", null: false
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bomba_id", "numero"], name: "index_bicos_on_bomba_id_and_numero", unique: true
    t.index ["bomba_id"], name: "index_bicos_on_bomba_id"
    t.index ["codigo"], name: "index_bicos_on_codigo", unique: true
    t.index ["tanque_id"], name: "index_bicos_on_tanque_id"
    t.check_constraint "encerrante_litros >= 0::numeric", name: "chk_bicos_encerrante_non_negative"
    t.check_constraint "numero > 0", name: "chk_bicos_numero_positive"
  end

  create_table "bombas", force: :cascade do |t|
    t.string "codigo", null: false
    t.text "descricao"
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_bombas_on_codigo", unique: true
  end

  create_table "caixas", force: :cascade do |t|
    t.bigint "escala_id", null: false
    t.bigint "funcionario_id", null: false
    t.datetime "aberto_em", null: false
    t.datetime "fechado_em"
    t.decimal "valor_inicial", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "valor_final", precision: 12, scale: 2
    t.string "status", default: "aberto", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["escala_id"], name: "index_caixas_on_escala_id", unique: true
    t.index ["funcionario_id"], name: "index_caixas_on_funcionario_id"
    t.check_constraint "fechado_em IS NULL OR fechado_em >= aberto_em", name: "chk_caixas_periodo"
    t.check_constraint "status::text = ANY (ARRAY['aberto'::character varying, 'fechado'::character varying, 'cancelado'::character varying]::text[])", name: "chk_caixas_status"
    t.check_constraint "valor_final IS NULL OR valor_final >= 0::numeric", name: "chk_caixas_valor_final"
    t.check_constraint "valor_inicial >= 0::numeric", name: "chk_caixas_valor_inicial"
  end

  create_table "cargo_permissoes", force: :cascade do |t|
    t.bigint "cargo_id", null: false
    t.bigint "permissao_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cargo_id", "permissao_id"], name: "index_cargo_permissoes_on_cargo_id_and_permissao_id", unique: true
    t.index ["cargo_id"], name: "index_cargo_permissoes_on_cargo_id"
    t.index ["permissao_id"], name: "index_cargo_permissoes_on_permissao_id"
  end

  create_table "cargos", force: :cascade do |t|
    t.string "nome", null: false
    t.text "descricao"
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_cargos_on_nome", unique: true
  end

  create_table "categorias", force: :cascade do |t|
    t.string "nome", null: false
    t.text "descricao"
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_categorias_on_nome", unique: true
  end

  create_table "cliente_pessoas_fisicas", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.string "nome", null: false
    t.string "cpf", limit: 11, null: false
    t.date "data_nascimento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_cliente_pessoas_fisicas_on_cliente_id", unique: true
    t.index ["cpf"], name: "index_cliente_pessoas_fisicas_on_cpf", unique: true
    t.check_constraint "char_length(cpf::text) = 11", name: "chk_cliente_pessoas_fisicas_cpf_length"
  end

  create_table "cliente_pessoas_juridicas", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.string "razao_social", null: false
    t.string "nome_fantasia"
    t.string "cnpj", limit: 14, null: false
    t.string "inscricao_estadual"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_cliente_pessoas_juridicas_on_cliente_id", unique: true
    t.index ["cnpj"], name: "index_cliente_pessoas_juridicas_on_cnpj", unique: true
    t.check_constraint "char_length(cnpj::text) = 14", name: "chk_cliente_pessoas_juridicas_cnpj_length"
  end

  create_table "clientes", force: :cascade do |t|
    t.bigint "endereco_id"
    t.string "tipo", null: false
    t.string "email"
    t.string "telefone"
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["endereco_id"], name: "index_clientes_on_endereco_id"
    t.index ["tipo"], name: "index_clientes_on_tipo"
    t.check_constraint "tipo::text = ANY (ARRAY['pf'::character varying, 'pj'::character varying]::text[])", name: "chk_clientes_tipo"
  end

  create_table "combustiveis", force: :cascade do |t|
    t.string "nome", null: false
    t.string "tipo", null: false
    t.string "codigo_anp", null: false
    t.string "unidade_medida", default: "litro", null: false
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo_anp"], name: "index_combustiveis_on_codigo_anp", unique: true
    t.index ["nome"], name: "index_combustiveis_on_nome", unique: true
  end

  create_table "enderecos", force: :cascade do |t|
    t.string "logradouro", null: false
    t.string "numero", null: false
    t.string "complemento"
    t.string "bairro", null: false
    t.string "cidade", null: false
    t.string "estado", limit: 2, null: false
    t.string "cep", limit: 8, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cep"], name: "index_enderecos_on_cep"
    t.check_constraint "char_length(cep::text) = 8", name: "chk_enderecos_cep_length"
    t.check_constraint "char_length(estado::text) = 2", name: "chk_enderecos_estado_length"
  end

  create_table "escalas", force: :cascade do |t|
    t.bigint "funcionario_id", null: false
    t.bigint "turno_id", null: false
    t.date "data", null: false
    t.string "status", default: "prevista", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["funcionario_id", "turno_id", "data"], name: "index_escalas_on_funcionario_id_and_turno_id_and_data", unique: true
    t.index ["funcionario_id"], name: "index_escalas_on_funcionario_id"
    t.index ["turno_id"], name: "index_escalas_on_turno_id"
    t.check_constraint "status::text = ANY (ARRAY['prevista'::character varying, 'realizada'::character varying, 'cancelada'::character varying]::text[])", name: "chk_escalas_status"
  end

  create_table "estoques", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.decimal "quantidade", precision: 12, scale: 3, default: "0.0", null: false
    t.decimal "quantidade_minima", precision: 12, scale: 3, default: "0.0", null: false
    t.string "localizacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_estoques_on_produto_id", unique: true
    t.check_constraint "quantidade >= 0::numeric", name: "chk_estoques_quantidade"
    t.check_constraint "quantidade_minima >= 0::numeric", name: "chk_estoques_quantidade_minima"
  end

  create_table "fornecedores", force: :cascade do |t|
    t.bigint "endereco_id"
    t.string "razao_social", null: false
    t.string "nome_fantasia"
    t.string "cnpj", limit: 14, null: false
    t.string "inscricao_estadual"
    t.string "email"
    t.string "telefone"
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cnpj"], name: "index_fornecedores_on_cnpj", unique: true
    t.index ["endereco_id"], name: "index_fornecedores_on_endereco_id"
    t.check_constraint "char_length(cnpj::text) = 14", name: "chk_fornecedores_cnpj_length"
  end

  create_table "frotas", force: :cascade do |t|
    t.bigint "cliente_id", null: false
    t.string "nome", null: false
    t.string "codigo", null: false
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id", "codigo"], name: "index_frotas_on_cliente_id_and_codigo", unique: true
    t.index ["cliente_id"], name: "index_frotas_on_cliente_id"
  end

  create_table "funcionarios", force: :cascade do |t|
    t.bigint "endereco_id"
    t.bigint "cargo_id", null: false
    t.string "nome", null: false
    t.string "cpf", limit: 11, null: false
    t.string "email"
    t.string "telefone"
    t.date "data_admissao", null: false
    t.date "data_demissao"
    t.decimal "salario", precision: 12, scale: 2, default: "0.0", null: false
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cargo_id"], name: "index_funcionarios_on_cargo_id"
    t.index ["cpf"], name: "index_funcionarios_on_cpf", unique: true
    t.index ["email"], name: "index_funcionarios_on_email", unique: true
    t.index ["endereco_id"], name: "index_funcionarios_on_endereco_id"
    t.check_constraint "char_length(cpf::text) = 11", name: "chk_funcionarios_cpf_length"
    t.check_constraint "data_demissao IS NULL OR data_demissao >= data_admissao", name: "chk_funcionarios_datas"
    t.check_constraint "salario >= 0::numeric", name: "chk_funcionarios_salario_non_negative"
  end

  create_table "historico_precos", force: :cascade do |t|
    t.bigint "combustivel_id", null: false
    t.decimal "preco", precision: 10, scale: 3, null: false
    t.datetime "vigente_em", null: false
    t.datetime "encerrado_em"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["combustivel_id", "vigente_em"], name: "index_historico_precos_on_combustivel_id_and_vigente_em", unique: true
    t.index ["combustivel_id"], name: "index_historico_precos_on_combustivel_id"
    t.check_constraint "encerrado_em IS NULL OR encerrado_em > vigente_em", name: "chk_historico_precos_periodo"
    t.check_constraint "preco > 0::numeric", name: "chk_historico_precos_preco_positive"
  end

  create_table "manutencoes", force: :cascade do |t|
    t.bigint "tanque_id"
    t.bigint "bomba_id"
    t.bigint "bico_id"
    t.string "tipo", null: false
    t.text "descricao", null: false
    t.datetime "iniciada_em", null: false
    t.datetime "finalizada_em"
    t.decimal "custo", precision: 12, scale: 2, default: "0.0", null: false
    t.string "status", default: "aberta", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bico_id"], name: "index_manutencoes_on_bico_id"
    t.index ["bomba_id"], name: "index_manutencoes_on_bomba_id"
    t.index ["status"], name: "index_manutencoes_on_status"
    t.index ["tanque_id"], name: "index_manutencoes_on_tanque_id"
    t.check_constraint "custo >= 0::numeric", name: "chk_manutencoes_custo_non_negative"
    t.check_constraint "finalizada_em IS NULL OR finalizada_em >= iniciada_em", name: "chk_manutencoes_periodo"
    t.check_constraint "num_nonnulls(tanque_id, bomba_id, bico_id) = 1", name: "chk_manutencoes_um_equipamento"
    t.check_constraint "status::text = ANY (ARRAY['aberta'::character varying, 'concluida'::character varying, 'cancelada'::character varying]::text[])", name: "chk_manutencoes_status"
  end

  create_table "nota_fiscal_itens", force: :cascade do |t|
    t.bigint "nota_fiscal_id", null: false
    t.bigint "produto_id", null: false
    t.decimal "quantidade", precision: 12, scale: 3, null: false
    t.decimal "valor_unitario", precision: 12, scale: 2, null: false
    t.decimal "valor_total", precision: 14, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nota_fiscal_id"], name: "index_nota_fiscal_itens_on_nota_fiscal_id"
    t.index ["produto_id"], name: "index_nota_fiscal_itens_on_produto_id"
    t.check_constraint "quantidade > 0::numeric", name: "chk_nota_fiscal_itens_quantidade"
    t.check_constraint "valor_total >= 0::numeric", name: "chk_nota_fiscal_itens_valor_total"
    t.check_constraint "valor_unitario >= 0::numeric", name: "chk_nota_fiscal_itens_valor_unitario"
  end

  create_table "notas_fiscais", force: :cascade do |t|
    t.bigint "fornecedor_id", null: false
    t.string "numero", null: false
    t.string "serie", null: false
    t.string "chave_acesso", limit: 44, null: false
    t.date "data_emissao", null: false
    t.decimal "valor_total", precision: 14, scale: 2, default: "0.0", null: false
    t.string "status", default: "emitida", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chave_acesso"], name: "index_notas_fiscais_on_chave_acesso", unique: true
    t.index ["fornecedor_id", "numero", "serie"], name: "index_notas_fiscais_on_fornecedor_id_and_numero_and_serie", unique: true
    t.index ["fornecedor_id"], name: "index_notas_fiscais_on_fornecedor_id"
    t.check_constraint "char_length(chave_acesso::text) = 44", name: "chk_notas_fiscais_chave_length"
    t.check_constraint "status::text = ANY (ARRAY['emitida'::character varying, 'cancelada'::character varying, 'recebida'::character varying]::text[])", name: "chk_notas_fiscais_status"
    t.check_constraint "valor_total >= 0::numeric", name: "chk_notas_fiscais_valor_total"
  end

  create_table "oleos", force: :cascade do |t|
    t.bigint "produto_id", null: false
    t.string "viscosidade", null: false
    t.string "especificacao"
    t.decimal "volume_litros", precision: 8, scale: 3, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_oleos_on_produto_id", unique: true
    t.check_constraint "volume_litros > 0::numeric", name: "chk_oleos_volume_positive"
  end

  create_table "pagamentos", force: :cascade do |t|
    t.bigint "venda_id", null: false
    t.bigint "caixa_id", null: false
    t.string "forma", null: false
    t.decimal "valor", precision: 14, scale: 2, null: false
    t.string "status", default: "pendente", null: false
    t.datetime "pago_em"
    t.string "nsu"
    t.string "codigo_autorizacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caixa_id"], name: "index_pagamentos_on_caixa_id"
    t.index ["venda_id", "forma"], name: "index_pagamentos_on_venda_id_and_forma"
    t.index ["venda_id"], name: "index_pagamentos_on_venda_id"
    t.check_constraint "forma::text = ANY (ARRAY['dinheiro'::character varying, 'cartao_credito'::character varying, 'cartao_debito'::character varying, 'pix'::character varying, 'voucher'::character varying, 'boleto'::character varying]::text[])", name: "chk_pagamentos_forma"
    t.check_constraint "status::text = ANY (ARRAY['pendente'::character varying, 'aprovado'::character varying, 'recusado'::character varying, 'cancelado'::character varying, 'estornado'::character varying]::text[])", name: "chk_pagamentos_status"
    t.check_constraint "valor > 0::numeric", name: "chk_pagamentos_valor"
  end

  create_table "permissoes", force: :cascade do |t|
    t.string "chave", null: false
    t.string "nome", null: false
    t.text "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chave"], name: "index_permissoes_on_chave", unique: true
  end

  create_table "produtos", force: :cascade do |t|
    t.bigint "categoria_id", null: false
    t.string "nome", null: false
    t.string "sku", null: false
    t.string "codigo_barras"
    t.string "unidade_medida", default: "unidade", null: false
    t.decimal "preco_venda", precision: 12, scale: 2, null: false
    t.decimal "custo_medio", precision: 12, scale: 2, default: "0.0", null: false
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["categoria_id"], name: "index_produtos_on_categoria_id"
    t.index ["codigo_barras"], name: "index_produtos_on_codigo_barras", unique: true
    t.index ["sku"], name: "index_produtos_on_sku", unique: true
    t.check_constraint "custo_medio >= 0::numeric", name: "chk_produtos_custo_medio"
    t.check_constraint "preco_venda >= 0::numeric", name: "chk_produtos_preco_venda"
  end

  create_table "tanques", force: :cascade do |t|
    t.bigint "combustivel_id", null: false
    t.string "codigo", null: false
    t.decimal "capacidade_litros", precision: 12, scale: 3, null: false
    t.decimal "volume_atual_litros", precision: 12, scale: 3, default: "0.0", null: false
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codigo"], name: "index_tanques_on_codigo", unique: true
    t.index ["combustivel_id"], name: "index_tanques_on_combustivel_id"
    t.check_constraint "capacidade_litros > 0::numeric", name: "chk_tanques_capacidade_positive"
    t.check_constraint "volume_atual_litros <= capacidade_litros", name: "chk_tanques_volume_capacity"
    t.check_constraint "volume_atual_litros >= 0::numeric", name: "chk_tanques_volume_non_negative"
  end

  create_table "turnos", force: :cascade do |t|
    t.string "nome", null: false
    t.time "hora_inicio", null: false
    t.time "hora_fim", null: false
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["nome"], name: "index_turnos_on_nome", unique: true
  end

  create_table "veiculos", force: :cascade do |t|
    t.bigint "cliente_id"
    t.bigint "frota_id"
    t.string "placa", limit: 7, null: false
    t.string "marca"
    t.string "modelo"
    t.integer "ano"
    t.string "cor"
    t.string "tipo"
    t.boolean "ativo", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cliente_id"], name: "index_veiculos_on_cliente_id"
    t.index ["frota_id"], name: "index_veiculos_on_frota_id"
    t.index ["placa"], name: "index_veiculos_on_placa", unique: true
    t.check_constraint "ano IS NULL OR ano >= 1900 AND ano <= 2100", name: "chk_veiculos_ano"
    t.check_constraint "char_length(placa::text) = 7", name: "chk_veiculos_placa_length"
    t.check_constraint "num_nonnulls(cliente_id, frota_id) >= 1", name: "chk_veiculos_proprietario"
  end

  create_table "venda_itens", force: :cascade do |t|
    t.bigint "venda_id", null: false
    t.bigint "produto_id"
    t.bigint "combustivel_id"
    t.bigint "bico_id"
    t.string "descricao", null: false
    t.decimal "quantidade", precision: 12, scale: 3, null: false
    t.decimal "valor_unitario", precision: 12, scale: 3, null: false
    t.decimal "desconto", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 14, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bico_id"], name: "index_venda_itens_on_bico_id"
    t.index ["combustivel_id"], name: "index_venda_itens_on_combustivel_id"
    t.index ["produto_id"], name: "index_venda_itens_on_produto_id"
    t.index ["venda_id"], name: "index_venda_itens_on_venda_id"
    t.check_constraint "bico_id IS NULL OR combustivel_id IS NOT NULL", name: "chk_venda_itens_bico_combustivel"
    t.check_constraint "desconto >= 0::numeric", name: "chk_venda_itens_desconto"
    t.check_constraint "produto_id IS NOT NULL AND combustivel_id IS NULL OR produto_id IS NULL AND combustivel_id IS NOT NULL", name: "chk_venda_itens_tipo_item"
    t.check_constraint "quantidade > 0::numeric", name: "chk_venda_itens_quantidade"
    t.check_constraint "total >= 0::numeric", name: "chk_venda_itens_total"
    t.check_constraint "valor_unitario >= 0::numeric", name: "chk_venda_itens_valor_unitario"
  end

  create_table "vendas", force: :cascade do |t|
    t.bigint "cliente_id"
    t.bigint "funcionario_id", null: false
    t.bigint "caixa_id", null: false
    t.bigint "veiculo_id"
    t.string "numero", null: false
    t.datetime "vendida_em", null: false
    t.decimal "subtotal", precision: 14, scale: 2, default: "0.0", null: false
    t.decimal "desconto", precision: 14, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 14, scale: 2, default: "0.0", null: false
    t.string "status", default: "aberta", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caixa_id"], name: "index_vendas_on_caixa_id"
    t.index ["cliente_id"], name: "index_vendas_on_cliente_id"
    t.index ["funcionario_id"], name: "index_vendas_on_funcionario_id"
    t.index ["numero"], name: "index_vendas_on_numero", unique: true
    t.index ["veiculo_id"], name: "index_vendas_on_veiculo_id"
    t.index ["vendida_em"], name: "index_vendas_on_vendida_em"
    t.check_constraint "desconto <= subtotal", name: "chk_vendas_desconto_subtotal"
    t.check_constraint "desconto >= 0::numeric", name: "chk_vendas_desconto"
    t.check_constraint "status::text = ANY (ARRAY['aberta'::character varying, 'finalizada'::character varying, 'cancelada'::character varying]::text[])", name: "chk_vendas_status"
    t.check_constraint "subtotal >= 0::numeric", name: "chk_vendas_subtotal"
    t.check_constraint "total >= 0::numeric", name: "chk_vendas_total"
  end

  add_foreign_key "afericoes", "bicos"
  add_foreign_key "afericoes", "funcionarios"
  add_foreign_key "bicos", "bombas"
  add_foreign_key "bicos", "tanques"
  add_foreign_key "caixas", "escalas"
  add_foreign_key "caixas", "funcionarios"
  add_foreign_key "cargo_permissoes", "cargos"
  add_foreign_key "cargo_permissoes", "permissoes", column: "permissao_id"
  add_foreign_key "cliente_pessoas_fisicas", "clientes"
  add_foreign_key "cliente_pessoas_juridicas", "clientes"
  add_foreign_key "clientes", "enderecos"
  add_foreign_key "escalas", "funcionarios"
  add_foreign_key "escalas", "turnos"
  add_foreign_key "estoques", "produtos"
  add_foreign_key "fornecedores", "enderecos"
  add_foreign_key "frotas", "clientes"
  add_foreign_key "funcionarios", "cargos"
  add_foreign_key "funcionarios", "enderecos"
  add_foreign_key "historico_precos", "combustiveis", column: "combustivel_id"
  add_foreign_key "manutencoes", "bicos"
  add_foreign_key "manutencoes", "bombas"
  add_foreign_key "manutencoes", "tanques"
  add_foreign_key "nota_fiscal_itens", "notas_fiscais", column: "nota_fiscal_id"
  add_foreign_key "nota_fiscal_itens", "produtos"
  add_foreign_key "notas_fiscais", "fornecedores", column: "fornecedor_id"
  add_foreign_key "oleos", "produtos"
  add_foreign_key "pagamentos", "caixas"
  add_foreign_key "pagamentos", "vendas"
  add_foreign_key "produtos", "categorias"
  add_foreign_key "tanques", "combustiveis", column: "combustivel_id"
  add_foreign_key "veiculos", "clientes"
  add_foreign_key "veiculos", "frotas"
  add_foreign_key "venda_itens", "bicos"
  add_foreign_key "venda_itens", "combustiveis", column: "combustivel_id"
  add_foreign_key "venda_itens", "produtos"
  add_foreign_key "venda_itens", "vendas"
  add_foreign_key "vendas", "caixas"
  add_foreign_key "vendas", "clientes"
  add_foreign_key "vendas", "funcionarios"
  add_foreign_key "vendas", "veiculos"
end
