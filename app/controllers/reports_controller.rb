class ReportsController < ApplicationController
  rescue_from Reports::ReportError, with: :render_report_error

  def vendas_turno
    render json: Reports::VendasTurnoReportService.call(params.permit(:inicio, :fim))
  end

  def estoque_critico
    render json: Reports::EstoqueCriticoReportService.call
  end

  def extrato_frota
    render json: Reports::ExtratoFrotaReportService.call(params.permit(:mes, :cliente_id))
  end

  private

  def render_report_error(error)
    render json: { error: { code: "bad_request", message: error.message } }, status: :bad_request
  end
end
