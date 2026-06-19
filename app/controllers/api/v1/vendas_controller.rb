module Api
  module V1
    class VendasController < BaseCrudController
      self.model_class = Venda
      self.permitted_attributes = %i[
        cliente_id funcionario_id caixa_id veiculo_id numero vendida_em subtotal desconto total status
      ]

      rescue_from SaleCreationService::Error, with: :render_sale_creation_error

      def create
        sale = SaleCreationService.call(sale_creation_params.to_h)

        render json: sale, status: :created
      end

      private

      def sale_creation_params
        source = params[:venda].presence || params

        source.permit(
          :cliente_id,
          :funcionario_id,
          :caixa_id,
          :veiculo_id,
          :numero,
          :vendida_em,
          :desconto,
          itens: %i[produto_id combustivel_id bico_id descricao quantidade desconto],
          pagamentos: %i[forma valor status pago_em nsu codigo_autorizacao]
        )
      end

      def render_sale_creation_error(error)
        render json: error_payload("unprocessable_entity", error.message, details: error.details), status: :unprocessable_entity
      end
    end
  end
end
