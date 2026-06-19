class CreateFuelStationSchema < ActiveRecord::Migration[7.2]
  def change
    create_table :enderecos do |t|
      t.string :logradouro, null: false
      t.string :numero, null: false
      t.string :complemento
      t.string :bairro, null: false
      t.string :cidade, null: false
      t.string :estado, null: false, limit: 2
      t.string :cep, null: false, limit: 8

      t.timestamps
    end

    add_index :enderecos, :cep
    add_check_constraint :enderecos, "char_length(estado) = 2", name: "chk_enderecos_estado_length"
    add_check_constraint :enderecos, "char_length(cep) = 8", name: "chk_enderecos_cep_length"

    create_table :cargos do |t|
      t.string :nome, null: false
      t.text :descricao
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :cargos, :nome, unique: true

    create_table :permissoes do |t|
      t.string :chave, null: false
      t.string :nome, null: false
      t.text :descricao

      t.timestamps
    end

    add_index :permissoes, :chave, unique: true

    create_table :cargo_permissoes do |t|
      t.references :cargo, null: false, foreign_key: { to_table: :cargos }
      t.references :permissao, null: false, foreign_key: { to_table: :permissoes }

      t.timestamps
    end

    add_index :cargo_permissoes, %i[cargo_id permissao_id], unique: true

    create_table :funcionarios do |t|
      t.references :endereco, foreign_key: { to_table: :enderecos }
      t.references :cargo, null: false, foreign_key: { to_table: :cargos }
      t.string :nome, null: false
      t.string :cpf, null: false, limit: 11
      t.string :email
      t.string :telefone
      t.date :data_admissao, null: false
      t.date :data_demissao
      t.decimal :salario, precision: 12, scale: 2, null: false, default: 0
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :funcionarios, :cpf, unique: true
    add_index :funcionarios, :email, unique: true
    add_check_constraint :funcionarios, "char_length(cpf) = 11", name: "chk_funcionarios_cpf_length"
    add_check_constraint :funcionarios, "salario >= 0", name: "chk_funcionarios_salario_non_negative"
    add_check_constraint :funcionarios, "data_demissao IS NULL OR data_demissao >= data_admissao", name: "chk_funcionarios_datas"

    create_table :combustiveis do |t|
      t.string :nome, null: false
      t.string :tipo, null: false
      t.string :codigo_anp, null: false
      t.string :unidade_medida, null: false, default: "litro"
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :combustiveis, :nome, unique: true
    add_index :combustiveis, :codigo_anp, unique: true

    create_table :historico_precos do |t|
      t.references :combustivel, null: false, foreign_key: { to_table: :combustiveis }
      t.decimal :preco, precision: 10, scale: 3, null: false
      t.datetime :vigente_em, null: false
      t.datetime :encerrado_em

      t.timestamps
    end

    add_index :historico_precos, %i[combustivel_id vigente_em], unique: true
    add_check_constraint :historico_precos, "preco > 0", name: "chk_historico_precos_preco_positive"
    add_check_constraint :historico_precos, "encerrado_em IS NULL OR encerrado_em > vigente_em", name: "chk_historico_precos_periodo"

    create_table :tanques do |t|
      t.references :combustivel, null: false, foreign_key: { to_table: :combustiveis }
      t.string :codigo, null: false
      t.decimal :capacidade_litros, precision: 12, scale: 3, null: false
      t.decimal :volume_atual_litros, precision: 12, scale: 3, null: false, default: 0
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :tanques, :codigo, unique: true
    add_check_constraint :tanques, "capacidade_litros > 0", name: "chk_tanques_capacidade_positive"
    add_check_constraint :tanques, "volume_atual_litros >= 0", name: "chk_tanques_volume_non_negative"
    add_check_constraint :tanques, "volume_atual_litros <= capacidade_litros", name: "chk_tanques_volume_capacity"

    create_table :bombas do |t|
      t.string :codigo, null: false
      t.text :descricao
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :bombas, :codigo, unique: true

    create_table :bicos do |t|
      t.references :bomba, null: false, foreign_key: { to_table: :bombas }
      t.references :tanque, null: false, foreign_key: { to_table: :tanques }
      t.integer :numero, null: false
      t.string :codigo, null: false
      t.decimal :encerrante_litros, precision: 14, scale: 3, null: false, default: 0
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :bicos, :codigo, unique: true
    add_index :bicos, %i[bomba_id numero], unique: true
    add_check_constraint :bicos, "numero > 0", name: "chk_bicos_numero_positive"
    add_check_constraint :bicos, "encerrante_litros >= 0", name: "chk_bicos_encerrante_non_negative"

    create_table :manutencoes do |t|
      t.references :tanque, foreign_key: { to_table: :tanques }
      t.references :bomba, foreign_key: { to_table: :bombas }
      t.references :bico, foreign_key: { to_table: :bicos }
      t.string :tipo, null: false
      t.text :descricao, null: false
      t.datetime :iniciada_em, null: false
      t.datetime :finalizada_em
      t.decimal :custo, precision: 12, scale: 2, null: false, default: 0
      t.string :status, null: false, default: "aberta"

      t.timestamps
    end

    add_index :manutencoes, :status
    add_check_constraint :manutencoes, "num_nonnulls(tanque_id, bomba_id, bico_id) = 1", name: "chk_manutencoes_um_equipamento"
    add_check_constraint :manutencoes, "custo >= 0", name: "chk_manutencoes_custo_non_negative"
    add_check_constraint :manutencoes, "finalizada_em IS NULL OR finalizada_em >= iniciada_em", name: "chk_manutencoes_periodo"
    add_check_constraint :manutencoes, "status IN ('aberta', 'concluida', 'cancelada')", name: "chk_manutencoes_status"

    create_table :afericoes do |t|
      t.references :bico, null: false, foreign_key: { to_table: :bicos }
      t.references :funcionario, null: false, foreign_key: { to_table: :funcionarios }
      t.datetime :realizada_em, null: false
      t.decimal :volume_indicado_litros, precision: 10, scale: 3, null: false
      t.decimal :volume_aferido_litros, precision: 10, scale: 3, null: false
      t.decimal :diferenca_litros, precision: 10, scale: 3, null: false
      t.text :observacoes

      t.timestamps
    end

    add_index :afericoes, %i[bico_id realizada_em]
    add_check_constraint :afericoes, "volume_indicado_litros >= 0", name: "chk_afericoes_volume_indicado"
    add_check_constraint :afericoes, "volume_aferido_litros >= 0", name: "chk_afericoes_volume_aferido"

    create_table :turnos do |t|
      t.string :nome, null: false
      t.time :hora_inicio, null: false
      t.time :hora_fim, null: false
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :turnos, :nome, unique: true

    create_table :escalas do |t|
      t.references :funcionario, null: false, foreign_key: { to_table: :funcionarios }
      t.references :turno, null: false, foreign_key: { to_table: :turnos }
      t.date :data, null: false
      t.string :status, null: false, default: "prevista"

      t.timestamps
    end

    add_index :escalas, %i[funcionario_id turno_id data], unique: true
    add_check_constraint :escalas, "status IN ('prevista', 'realizada', 'cancelada')", name: "chk_escalas_status"

    create_table :caixas do |t|
      t.references :escala, null: false, foreign_key: { to_table: :escalas }, index: false
      t.references :funcionario, null: false, foreign_key: { to_table: :funcionarios }
      t.datetime :aberto_em, null: false
      t.datetime :fechado_em
      t.decimal :valor_inicial, precision: 12, scale: 2, null: false, default: 0
      t.decimal :valor_final, precision: 12, scale: 2
      t.string :status, null: false, default: "aberto"

      t.timestamps
    end

    add_index :caixas, :escala_id, unique: true
    add_check_constraint :caixas, "valor_inicial >= 0", name: "chk_caixas_valor_inicial"
    add_check_constraint :caixas, "valor_final IS NULL OR valor_final >= 0", name: "chk_caixas_valor_final"
    add_check_constraint :caixas, "fechado_em IS NULL OR fechado_em >= aberto_em", name: "chk_caixas_periodo"
    add_check_constraint :caixas, "status IN ('aberto', 'fechado', 'cancelado')", name: "chk_caixas_status"

    create_table :fechamento_caixas do |t|
      t.references :caixa, null: false, foreign_key: { to_table: :caixas }, index: false
      t.references :funcionario, null: false, foreign_key: { to_table: :funcionarios }
      t.datetime :fechado_em, null: false
      t.decimal :valor_informado, precision: 14, scale: 2, null: false
      t.decimal :valor_sistema, precision: 14, scale: 2, null: false
      t.decimal :diferenca, precision: 14, scale: 2, null: false, default: 0
      t.text :observacoes

      t.timestamps
    end

    add_index :fechamento_caixas, :caixa_id, unique: true
    add_check_constraint :fechamento_caixas, "valor_informado >= 0", name: "chk_fechamento_caixas_valor_informado"
    add_check_constraint :fechamento_caixas, "valor_sistema >= 0", name: "chk_fechamento_caixas_valor_sistema"

    create_table :categorias do |t|
      t.string :nome, null: false
      t.text :descricao
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :categorias, :nome, unique: true

    create_table :produtos do |t|
      t.references :categoria, null: false, foreign_key: { to_table: :categorias }
      t.string :nome, null: false
      t.string :sku, null: false
      t.string :codigo_barras
      t.string :unidade_medida, null: false, default: "unidade"
      t.decimal :preco_venda, precision: 12, scale: 2, null: false
      t.decimal :custo_medio, precision: 12, scale: 2, null: false, default: 0
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :produtos, :sku, unique: true
    add_index :produtos, :codigo_barras, unique: true
    add_check_constraint :produtos, "preco_venda >= 0", name: "chk_produtos_preco_venda"
    add_check_constraint :produtos, "custo_medio >= 0", name: "chk_produtos_custo_medio"

    create_table :oleos do |t|
      t.references :produto, null: false, foreign_key: { to_table: :produtos }, index: false
      t.string :viscosidade, null: false
      t.string :especificacao
      t.decimal :volume_litros, precision: 8, scale: 3, null: false

      t.timestamps
    end

    add_index :oleos, :produto_id, unique: true
    add_check_constraint :oleos, "volume_litros > 0", name: "chk_oleos_volume_positive"

    create_table :estoques do |t|
      t.references :produto, null: false, foreign_key: { to_table: :produtos }, index: false
      t.decimal :quantidade, precision: 12, scale: 3, null: false, default: 0
      t.decimal :quantidade_minima, precision: 12, scale: 3, null: false, default: 0
      t.string :localizacao

      t.timestamps
    end

    add_index :estoques, :produto_id, unique: true
    add_check_constraint :estoques, "quantidade >= 0", name: "chk_estoques_quantidade"
    add_check_constraint :estoques, "quantidade_minima >= 0", name: "chk_estoques_quantidade_minima"

    create_table :movimentacao_estoques do |t|
      t.references :produto, null: false, foreign_key: { to_table: :produtos }
      t.references :funcionario, foreign_key: { to_table: :funcionarios }
      t.string :tipo, null: false
      t.decimal :quantidade, precision: 12, scale: 3, null: false
      t.decimal :saldo_apos, precision: 12, scale: 3, null: false
      t.string :origem
      t.text :observacoes
      t.datetime :movimentada_em, null: false

      t.timestamps
    end

    add_index :movimentacao_estoques, :movimentada_em
    add_check_constraint :movimentacao_estoques, "tipo IN ('entrada', 'saida', 'ajuste')", name: "chk_movimentacao_estoques_tipo"
    add_check_constraint :movimentacao_estoques, "quantidade <> 0", name: "chk_movimentacao_estoques_quantidade"
    add_check_constraint :movimentacao_estoques, "saldo_apos >= 0", name: "chk_movimentacao_estoques_saldo"

    create_table :fornecedores do |t|
      t.references :endereco, foreign_key: { to_table: :enderecos }
      t.string :razao_social, null: false
      t.string :nome_fantasia
      t.string :cnpj, null: false, limit: 14
      t.string :inscricao_estadual
      t.string :email
      t.string :telefone
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :fornecedores, :cnpj, unique: true
    add_check_constraint :fornecedores, "char_length(cnpj) = 14", name: "chk_fornecedores_cnpj_length"

    create_table :notas_fiscais do |t|
      t.references :fornecedor, null: false, foreign_key: { to_table: :fornecedores }
      t.string :numero, null: false
      t.string :serie, null: false
      t.string :chave_acesso, null: false, limit: 44
      t.date :data_emissao, null: false
      t.decimal :valor_total, precision: 14, scale: 2, null: false, default: 0
      t.string :status, null: false, default: "emitida"

      t.timestamps
    end

    add_index :notas_fiscais, :chave_acesso, unique: true
    add_index :notas_fiscais, %i[fornecedor_id numero serie], unique: true
    add_check_constraint :notas_fiscais, "char_length(chave_acesso) = 44", name: "chk_notas_fiscais_chave_length"
    add_check_constraint :notas_fiscais, "valor_total >= 0", name: "chk_notas_fiscais_valor_total"
    add_check_constraint :notas_fiscais, "status IN ('emitida', 'cancelada', 'recebida')", name: "chk_notas_fiscais_status"

    create_table :nota_fiscal_itens do |t|
      t.references :nota_fiscal, null: false, foreign_key: { to_table: :notas_fiscais }
      t.references :produto, null: false, foreign_key: { to_table: :produtos }
      t.decimal :quantidade, precision: 12, scale: 3, null: false
      t.decimal :valor_unitario, precision: 12, scale: 2, null: false
      t.decimal :valor_total, precision: 14, scale: 2, null: false

      t.timestamps
    end

    add_check_constraint :nota_fiscal_itens, "quantidade > 0", name: "chk_nota_fiscal_itens_quantidade"
    add_check_constraint :nota_fiscal_itens, "valor_unitario >= 0", name: "chk_nota_fiscal_itens_valor_unitario"
    add_check_constraint :nota_fiscal_itens, "valor_total >= 0", name: "chk_nota_fiscal_itens_valor_total"

    create_table :clientes do |t|
      t.references :endereco, foreign_key: { to_table: :enderecos }
      t.string :tipo, null: false
      t.string :email
      t.string :telefone
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :clientes, :tipo
    add_check_constraint :clientes, "tipo IN ('pf', 'pj')", name: "chk_clientes_tipo"

    create_table :cliente_pessoas_fisicas do |t|
      t.references :cliente, null: false, foreign_key: { to_table: :clientes }, index: false
      t.string :nome, null: false
      t.string :cpf, null: false, limit: 11
      t.date :data_nascimento

      t.timestamps
    end

    add_index :cliente_pessoas_fisicas, :cliente_id, unique: true
    add_index :cliente_pessoas_fisicas, :cpf, unique: true
    add_check_constraint :cliente_pessoas_fisicas, "char_length(cpf) = 11", name: "chk_cliente_pessoas_fisicas_cpf_length"

    create_table :cliente_pessoas_juridicas do |t|
      t.references :cliente, null: false, foreign_key: { to_table: :clientes }, index: false
      t.string :razao_social, null: false
      t.string :nome_fantasia
      t.string :cnpj, null: false, limit: 14
      t.string :inscricao_estadual

      t.timestamps
    end

    add_index :cliente_pessoas_juridicas, :cliente_id, unique: true
    add_index :cliente_pessoas_juridicas, :cnpj, unique: true
    add_check_constraint :cliente_pessoas_juridicas, "char_length(cnpj) = 14", name: "chk_cliente_pessoas_juridicas_cnpj_length"

    create_table :frotas do |t|
      t.references :cliente, null: false, foreign_key: { to_table: :clientes }
      t.string :nome, null: false
      t.string :codigo, null: false
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :frotas, %i[cliente_id codigo], unique: true

    create_table :veiculos do |t|
      t.references :cliente, foreign_key: { to_table: :clientes }
      t.references :frota, foreign_key: { to_table: :frotas }
      t.string :placa, null: false, limit: 7
      t.string :marca
      t.string :modelo
      t.integer :ano
      t.string :cor
      t.string :tipo
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :veiculos, :placa, unique: true
    add_check_constraint :veiculos, "char_length(placa) = 7", name: "chk_veiculos_placa_length"
    add_check_constraint :veiculos, "ano IS NULL OR ano BETWEEN 1900 AND 2100", name: "chk_veiculos_ano"
    add_check_constraint :veiculos, "num_nonnulls(cliente_id, frota_id) >= 1", name: "chk_veiculos_proprietario"

    create_table :vendas do |t|
      t.references :cliente, foreign_key: { to_table: :clientes }
      t.references :funcionario, null: false, foreign_key: { to_table: :funcionarios }
      t.references :caixa, null: false, foreign_key: { to_table: :caixas }
      t.references :veiculo, foreign_key: { to_table: :veiculos }
      t.string :numero, null: false
      t.datetime :vendida_em, null: false
      t.decimal :subtotal, precision: 14, scale: 2, null: false, default: 0
      t.decimal :desconto, precision: 14, scale: 2, null: false, default: 0
      t.decimal :total, precision: 14, scale: 2, null: false, default: 0
      t.string :status, null: false, default: "aberta"

      t.timestamps
    end

    add_index :vendas, :numero, unique: true
    add_index :vendas, :vendida_em
    add_check_constraint :vendas, "subtotal >= 0", name: "chk_vendas_subtotal"
    add_check_constraint :vendas, "desconto >= 0", name: "chk_vendas_desconto"
    add_check_constraint :vendas, "total >= 0", name: "chk_vendas_total"
    add_check_constraint :vendas, "desconto <= subtotal", name: "chk_vendas_desconto_subtotal"
    add_check_constraint :vendas, "status IN ('aberta', 'finalizada', 'cancelada')", name: "chk_vendas_status"

    create_table :formas_pagamento do |t|
      t.string :chave, null: false
      t.string :nome, null: false
      t.boolean :ativo, null: false, default: true

      t.timestamps
    end

    add_index :formas_pagamento, :chave, unique: true

    create_table :cupons_fiscais do |t|
      t.references :venda, null: false, foreign_key: { to_table: :vendas }, index: false
      t.string :numero, null: false
      t.string :serie, null: false
      t.string :chave_acesso, null: false, limit: 44
      t.datetime :emitido_em, null: false
      t.decimal :valor_total, precision: 14, scale: 2, null: false
      t.string :status, null: false, default: "emitido"

      t.timestamps
    end

    add_index :cupons_fiscais, :venda_id, unique: true
    add_index :cupons_fiscais, :chave_acesso, unique: true
    add_index :cupons_fiscais, %i[numero serie], unique: true
    add_check_constraint :cupons_fiscais, "char_length(chave_acesso) = 44", name: "chk_cupons_fiscais_chave_length"
    add_check_constraint :cupons_fiscais, "valor_total >= 0", name: "chk_cupons_fiscais_valor_total"
    add_check_constraint :cupons_fiscais, "status IN ('emitido', 'cancelado')", name: "chk_cupons_fiscais_status"

    create_table :contas_receber do |t|
      t.references :cliente, null: false, foreign_key: { to_table: :clientes }
      t.references :venda, null: false, foreign_key: { to_table: :vendas }, index: false
      t.string :numero, null: false
      t.decimal :valor_total, precision: 14, scale: 2, null: false
      t.decimal :saldo, precision: 14, scale: 2, null: false
      t.date :vencimento_em, null: false
      t.string :status, null: false, default: "aberta"

      t.timestamps
    end

    add_index :contas_receber, :venda_id, unique: true
    add_index :contas_receber, :numero, unique: true
    add_index :contas_receber, :status
    add_check_constraint :contas_receber, "valor_total >= 0", name: "chk_contas_receber_valor_total"
    add_check_constraint :contas_receber, "saldo >= 0", name: "chk_contas_receber_saldo"
    add_check_constraint :contas_receber, "saldo <= valor_total", name: "chk_contas_receber_saldo_total"
    add_check_constraint :contas_receber, "status IN ('aberta', 'paga', 'vencida', 'cancelada')", name: "chk_contas_receber_status"

    create_table :parcelas_receber do |t|
      t.references :conta_receber, null: false, foreign_key: { to_table: :contas_receber }
      t.integer :numero, null: false
      t.decimal :valor, precision: 14, scale: 2, null: false
      t.decimal :saldo, precision: 14, scale: 2, null: false
      t.date :vencimento_em, null: false
      t.datetime :paga_em
      t.string :status, null: false, default: "aberta"

      t.timestamps
    end

    add_index :parcelas_receber, %i[conta_receber_id numero], unique: true
    add_index :parcelas_receber, :status
    add_check_constraint :parcelas_receber, "numero > 0", name: "chk_parcelas_receber_numero"
    add_check_constraint :parcelas_receber, "valor > 0", name: "chk_parcelas_receber_valor"
    add_check_constraint :parcelas_receber, "saldo >= 0", name: "chk_parcelas_receber_saldo"
    add_check_constraint :parcelas_receber, "saldo <= valor", name: "chk_parcelas_receber_saldo_valor"
    add_check_constraint :parcelas_receber, "status IN ('aberta', 'paga', 'vencida', 'cancelada')", name: "chk_parcelas_receber_status"

    create_table :leituras_encerrantes do |t|
      t.references :bico, null: false, foreign_key: { to_table: :bicos }
      t.references :funcionario, null: false, foreign_key: { to_table: :funcionarios }
      t.decimal :encerrante_litros, precision: 14, scale: 3, null: false
      t.datetime :lida_em, null: false
      t.text :observacoes

      t.timestamps
    end

    add_index :leituras_encerrantes, %i[bico_id lida_em], unique: true
    add_check_constraint :leituras_encerrantes, "encerrante_litros >= 0", name: "chk_leituras_encerrantes_valor"

    create_table :calibracoes_bicos do |t|
      t.references :bico, null: false, foreign_key: { to_table: :bicos }
      t.references :funcionario, null: false, foreign_key: { to_table: :funcionarios }
      t.datetime :realizada_em, null: false
      t.decimal :vazao_litros_minuto, precision: 10, scale: 3, null: false
      t.decimal :desvio_percentual, precision: 8, scale: 4, null: false, default: 0
      t.string :status, null: false, default: "aprovada"
      t.text :observacoes

      t.timestamps
    end

    add_index :calibracoes_bicos, %i[bico_id realizada_em], unique: true
    add_check_constraint :calibracoes_bicos, "vazao_litros_minuto > 0", name: "chk_calibracoes_bicos_vazao"
    add_check_constraint :calibracoes_bicos, "status IN ('aprovada', 'reprovada')", name: "chk_calibracoes_bicos_status"

    create_table :venda_itens do |t|
      t.references :venda, null: false, foreign_key: { to_table: :vendas }
      t.references :produto, foreign_key: { to_table: :produtos }
      t.references :combustivel, foreign_key: { to_table: :combustiveis }
      t.references :bico, foreign_key: { to_table: :bicos }
      t.string :descricao, null: false
      t.decimal :quantidade, precision: 12, scale: 3, null: false
      t.decimal :valor_unitario, precision: 12, scale: 3, null: false
      t.decimal :desconto, precision: 12, scale: 2, null: false, default: 0
      t.decimal :total, precision: 14, scale: 2, null: false

      t.timestamps
    end

    add_check_constraint :venda_itens, "quantidade > 0", name: "chk_venda_itens_quantidade"
    add_check_constraint :venda_itens, "valor_unitario >= 0", name: "chk_venda_itens_valor_unitario"
    add_check_constraint :venda_itens, "desconto >= 0", name: "chk_venda_itens_desconto"
    add_check_constraint :venda_itens, "total >= 0", name: "chk_venda_itens_total"
    add_check_constraint :venda_itens, "(produto_id IS NOT NULL AND combustivel_id IS NULL) OR (produto_id IS NULL AND combustivel_id IS NOT NULL)", name: "chk_venda_itens_tipo_item"
    add_check_constraint :venda_itens, "bico_id IS NULL OR combustivel_id IS NOT NULL", name: "chk_venda_itens_bico_combustivel"

    create_table :movimentacao_tanques do |t|
      t.references :tanque, null: false, foreign_key: { to_table: :tanques }
      t.references :combustivel, null: false, foreign_key: { to_table: :combustiveis }
      t.references :venda_item, foreign_key: { to_table: :venda_itens }
      t.string :tipo, null: false
      t.decimal :volume_litros, precision: 12, scale: 3, null: false
      t.decimal :saldo_apos_litros, precision: 12, scale: 3, null: false
      t.datetime :movimentada_em, null: false
      t.text :observacoes

      t.timestamps
    end

    add_index :movimentacao_tanques, :movimentada_em
    add_check_constraint :movimentacao_tanques, "tipo IN ('entrada', 'saida', 'ajuste')", name: "chk_movimentacao_tanques_tipo"
    add_check_constraint :movimentacao_tanques, "volume_litros <> 0", name: "chk_movimentacao_tanques_volume"
    add_check_constraint :movimentacao_tanques, "saldo_apos_litros >= 0", name: "chk_movimentacao_tanques_saldo"

    create_table :pagamentos do |t|
      t.references :venda, null: false, foreign_key: { to_table: :vendas }
      t.references :caixa, null: false, foreign_key: { to_table: :caixas }
      t.references :forma_pagamento, foreign_key: { to_table: :formas_pagamento }
      t.string :forma, null: false
      t.decimal :valor, precision: 14, scale: 2, null: false
      t.string :status, null: false, default: "pendente"
      t.datetime :pago_em
      t.string :nsu
      t.string :codigo_autorizacao

      t.timestamps
    end

    add_index :pagamentos, %i[venda_id forma]
    add_check_constraint :pagamentos, "valor > 0", name: "chk_pagamentos_valor"
    add_check_constraint :pagamentos, "forma IN ('dinheiro', 'cartao_credito', 'cartao_debito', 'pix', 'voucher', 'boleto')", name: "chk_pagamentos_forma"
    add_check_constraint :pagamentos, "status IN ('pendente', 'aprovado', 'recusado', 'cancelado', 'estornado')", name: "chk_pagamentos_status"

    create_table :auditoria_eventos do |t|
      t.references :funcionario, foreign_key: { to_table: :funcionarios }
      t.string :entidade, null: false
      t.bigint :entidade_id
      t.string :acao, null: false
      t.jsonb :dados, null: false, default: {}
      t.datetime :ocorrido_em, null: false

      t.timestamps
    end

    add_index :auditoria_eventos, %i[entidade entidade_id]
    add_index :auditoria_eventos, :ocorrido_em
    add_check_constraint :auditoria_eventos, "acao IN ('criado', 'atualizado', 'removido', 'login', 'logout', 'erro')", name: "chk_auditoria_eventos_acao"
  end
end
