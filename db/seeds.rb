seed_time = Time.zone.local(2026, 6, 19, 8, 0, 0)
sale_number = "SEED-0001"
sale_exists = Venda.exists?(numero: sale_number)

def upsert_by(model, attributes, values = {})
  record = model.find_or_initialize_by(attributes)
  record.assign_attributes(values)
  record.save!
  record
end

manager_role = upsert_by(Cargo, { nome: "Gerente" }, descricao: "Responsavel pela operacao", ativo: true)
operator_role = upsert_by(Cargo, { nome: "Operador de caixa" }, descricao: "Atendimento e vendas", ativo: true)

manager = upsert_by(
  Funcionario,
  { cpf: "11122233344" },
  cargo: manager_role,
  nome: "Marina Gerente",
  email: "marina.gerente@example.com",
  telefone: "11999990001",
  data_admissao: Date.new(2024, 1, 10),
  salario: 6500,
  ativo: true
)

operator = upsert_by(
  Funcionario,
  { cpf: "22233344455" },
  cargo: operator_role,
  nome: "Paulo Operador",
  email: "paulo.operador@example.com",
  telefone: "11999990002",
  data_admissao: Date.new(2024, 3, 5),
  salario: 3200,
  ativo: true
)

morning_shift = upsert_by(Turno, { nome: "Manha" }, hora_inicio: "06:00", hora_fim: "14:00", ativo: true)
afternoon_shift = upsert_by(Turno, { nome: "Tarde" }, hora_inicio: "14:00", hora_fim: "22:00", ativo: true)
upsert_by(Turno, { nome: "Noite" }, hora_inicio: "22:00", hora_fim: "06:00", ativo: true)

shift_register = upsert_by(
  Escala,
  { funcionario: operator, turno: morning_shift, data: seed_time.to_date },
  status: "realizada"
)

cash_register = upsert_by(
  Caixa,
  { escala: shift_register },
  funcionario: operator,
  aberto_em: seed_time,
  fechado_em: nil,
  valor_inicial: 300,
  valor_final: nil,
  status: "aberto"
)

gasoline = upsert_by(Combustivel, { codigo_anp: "320102001" }, nome: "Gasolina Comum", tipo: "gasolina", unidade_medida: "litro", ativo: true)
diesel = upsert_by(Combustivel, { codigo_anp: "820101034" }, nome: "Diesel S10", tipo: "diesel", unidade_medida: "litro", ativo: true)
ethanol = upsert_by(Combustivel, { codigo_anp: "810101001" }, nome: "Etanol Hidratado", tipo: "etanol", unidade_medida: "litro", ativo: true)

{
  "dinheiro" => "Dinheiro",
  "cartao_credito" => "Cartao de credito",
  "cartao_debito" => "Cartao de debito",
  "pix" => "Pix",
  "voucher" => "Voucher",
  "boleto" => "Boleto"
}.each do |chave, nome|
  upsert_by(FormaPagamento, { chave: }, nome:, ativo: true)
end

upsert_by(HistoricoPreco, { combustivel: gasoline, vigente_em: Time.zone.local(2026, 1, 1) }, preco: 5.690, encerrado_em: nil)
upsert_by(HistoricoPreco, { combustivel: diesel, vigente_em: Time.zone.local(2026, 1, 1) }, preco: 5.990, encerrado_em: nil)
upsert_by(HistoricoPreco, { combustivel: ethanol, vigente_em: Time.zone.local(2026, 1, 1) }, preco: 3.990, encerrado_em: nil)

gasoline_tank = upsert_by(Tanque, { codigo: "TQ-GAS-01" }, combustivel: gasoline, capacidade_litros: 15_000, ativo: true)
diesel_tank = upsert_by(Tanque, { codigo: "TQ-DIE-01" }, combustivel: diesel, capacidade_litros: 20_000, ativo: true)
ethanol_tank = upsert_by(Tanque, { codigo: "TQ-ETA-01" }, combustivel: ethanol, capacidade_litros: 12_000, ativo: true)

unless sale_exists
  gasoline_tank.update!(volume_atual_litros: 8_500)
  diesel_tank.update!(volume_atual_litros: 12_000)
  ethanol_tank.update!(volume_atual_litros: 7_000)
end

pump_one = upsert_by(Bomba, { codigo: "BOMBA-01" }, descricao: "Ilha principal", ativo: true)
pump_two = upsert_by(Bomba, { codigo: "BOMBA-02" }, descricao: "Ilha diesel", ativo: true)

gasoline_nozzle_attrs = { bomba: pump_one, tanque: gasoline_tank, numero: 1, ativo: true }
diesel_nozzle_attrs = { bomba: pump_two, tanque: diesel_tank, numero: 1, ativo: true }
ethanol_nozzle_attrs = { bomba: pump_one, tanque: ethanol_tank, numero: 2, ativo: true }

gasoline_nozzle_attrs[:encerrante_litros] = 10_000 unless sale_exists
diesel_nozzle_attrs[:encerrante_litros] = 20_000 unless sale_exists
ethanol_nozzle_attrs[:encerrante_litros] = 5_000 unless sale_exists

upsert_by(Bico, { codigo: "B01-GAS" }, gasoline_nozzle_attrs)
diesel_nozzle = upsert_by(Bico, { codigo: "B02-DIE" }, diesel_nozzle_attrs)
upsert_by(Bico, { codigo: "B03-ETA" }, ethanol_nozzle_attrs)

lubricants = upsert_by(Categoria, { nome: "Lubrificantes" }, descricao: "Oleos e fluidos automotivos", ativo: true)
convenience = upsert_by(Categoria, { nome: "Conveniência" }, descricao: "Produtos da loja", ativo: true)

oil_product = upsert_by(
  Produto,
  { sku: "OLEO-15W40-1L" },
  categoria: lubricants,
  nome: "Oleo Lubrificante 15W40 1L",
  codigo_barras: "7890000000011",
  unidade_medida: "unidade",
  preco_venda: 42.90,
  custo_medio: 28.50,
  ativo: true
)

upsert_by(Oleo, { produto: oil_product }, viscosidade: "15W40", especificacao: "API SN", volume_litros: 1)
upsert_by(Estoque, { produto: oil_product }, quantidade: 3, quantidade_minima: 10, localizacao: "PRATELEIRA-A1")

water_product = upsert_by(
  Produto,
  { sku: "AGUA-500ML" },
  categoria: convenience,
  nome: "Agua Mineral 500ml",
  codigo_barras: "7890000000028",
  unidade_medida: "unidade",
  preco_venda: 2.50,
  custo_medio: 1.10,
  ativo: true
)

water_stock = Estoque.find_or_initialize_by(produto: water_product)
water_stock.assign_attributes(quantidade_minima: 20, localizacao: "GELADEIRA-01")
water_stock.quantidade = 100 if water_stock.new_record? || !sale_exists
water_stock.save!

individual_customer = upsert_by(Cliente, { email: "joao.cliente@example.com" }, tipo: "pf", telefone: "11988880001", ativo: true)
upsert_by(ClientePessoaFisica, { cliente: individual_customer }, nome: "Joao Cliente", cpf: "33344455566", data_nascimento: Date.new(1990, 5, 15))

fleet_customer = upsert_by(Cliente, { email: "frota@example.com" }, tipo: "pj", telefone: "1133334444", ativo: true)
upsert_by(ClientePessoaJuridica, { cliente: fleet_customer }, razao_social: "Transportes Exemplo Ltda", nome_fantasia: "Frota Exemplo", cnpj: "11222333000144")

fleet = upsert_by(Frota, { cliente: fleet_customer, codigo: "FROTA-001" }, nome: "Frota Entregas", ativo: true)
vehicle = upsert_by(
  Veiculo,
  { placa: "ABC1D23" },
  cliente: nil,
  frota: fleet,
  marca: "Ford",
  modelo: "Cargo",
  ano: 2022,
  cor: "Branca",
  tipo: "diesel",
  ativo: true
)

unless sale_exists
  sale = SaleCreationService.call(
    caixa_id: cash_register.id,
    funcionario_id: operator.id,
    cliente_id: fleet_customer.id,
    veiculo_id: vehicle.id,
    numero: sale_number,
    vendida_em: seed_time + 1.hour,
    itens: [
      { bico_id: diesel_nozzle.id, quantidade: 20, descricao: "Abastecimento Diesel S10" },
      { produto_id: water_product.id, quantidade: 10, descricao: "Agua Mineral 500ml" }
    ],
    pagamentos: [
      { forma: "dinheiro", valor: 20.00 },
      { forma: "cartao_credito", valor: 20.00, nsu: "NSU-SEED-CC" },
      { forma: "cartao_debito", valor: 20.00, nsu: "NSU-SEED-CD" },
      { forma: "pix", valor: 20.00, codigo_autorizacao: "PIX-SEED" },
      { forma: "voucher", valor: 20.00, codigo_autorizacao: "VOUCHER-SEED" },
      { forma: "boleto", valor: 44.80, codigo_autorizacao: "BOLETO-SEED" }
    ]
  )

  CupomFiscal.create!(
    venda: sale,
    numero: "CF-0001",
    serie: "1",
    chave_acesso: "35260611222333000144550010000000011000000010",
    emitido_em: sale.vendida_em,
    valor_total: sale.total,
    status: "emitido"
  )

  AuditoriaEvento.create!(
    funcionario: operator,
    entidade: "Venda",
    entidade_id: sale.id,
    acao: "criado",
    dados: { numero: sale.numero, total: sale.total.to_s },
    ocorrido_em: sale.created_at
  )
end

puts "Seeds carregados com sucesso. Venda seed: #{sale_number}. Formas de pagamento: #{Pagamento::FORMAS.join(', ')}."
