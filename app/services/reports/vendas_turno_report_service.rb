module Reports
  class VendasTurnoReportService
    def self.call(params = {})
      new(params).call
    end

    def initialize(params = {})
      @params = params.to_h.symbolize_keys
    end

    def call
      sales_totals.map do |(cash_register_id, shift_id), total|
        cash_register = cash_registers.fetch(cash_register_id)
        shift = shifts.fetch(shift_id)

        {
          caixa_id: cash_register_id,
          turno_id: shift_id,
          turno_nome: shift.nome,
          aberto_em: cash_register.aberto_em,
          fechado_em: cash_register.fechado_em,
          total_financeiro: total,
          volume_litros: volume_totals.fetch([ cash_register_id, shift_id ], BigDecimal("0"))
        }
      end
    end

    private

    attr_reader :params

    def filtered_sales
      relation = Venda.completed.joins(caixa: :escala)
      relation = relation.where("vendas.vendida_em >= ?", parse_datetime(params[:inicio], "inicio")) if params[:inicio].present?
      relation = relation.where("vendas.vendida_em <= ?", parse_datetime(params[:fim], "fim")) if params[:fim].present?
      relation
    end

    def sales_totals
      @sales_totals ||= filtered_sales.group("vendas.caixa_id", "escalas.turno_id").sum(:total)
    end

    def volume_totals
      @volume_totals ||= VendaItem
        .joins(venda: { caixa: :escala })
        .where(venda: filtered_sales.select(:id), produto_id: nil)
        .where.not(combustivel_id: nil)
        .group("vendas.caixa_id", "escalas.turno_id")
        .sum(:quantidade)
    end

    def cash_registers
      @cash_registers ||= Caixa.where(id: sales_totals.keys.map(&:first)).index_by(&:id)
    end

    def shifts
      @shifts ||= Turno.where(id: sales_totals.keys.map(&:last)).index_by(&:id)
    end

    def parse_datetime(value, field)
      Time.zone.parse(value.to_s)
    rescue ArgumentError
      raise ReportError, "#{field} invalido"
    end
  end
end
