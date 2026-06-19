module Api
  module V1
    class BaseCrudController < ApplicationController
      DEFAULT_LIMIT = 100
      MAX_LIMIT = 500

      class_attribute :model_class, :permitted_attributes, default: []

      before_action :set_resource, only: %i[show update destroy]

      rescue_from ActionController::BadRequest, with: :render_bad_request
      rescue_from ActionController::ParameterMissing, with: :render_bad_request
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
      rescue_from ActiveRecord::RecordNotDestroyed, with: :render_unprocessable_entity
      rescue_from ActiveRecord::InvalidForeignKey, with: :render_unprocessable_entity
      rescue_from ActiveRecord::RecordNotUnique, with: :render_unprocessable_entity

      def index
        render json: model_class.order(:id).limit(index_limit)
      end

      def show
        render json: @resource
      end

      def create
        resource = model_class.create!(resource_params)

        render json: resource, status: :created
      end

      def update
        @resource.update!(resource_params)

        render json: @resource
      end

      def destroy
        @resource.destroy!

        head :no_content
      end

      private

      def set_resource
        @resource = model_class.find(params[:id])
      end

      def index_limit
        return DEFAULT_LIMIT if params[:limit].blank?

        limit = Integer(params[:limit], exception: false)
        raise ActionController::BadRequest, "limit must be an integer between 1 and #{MAX_LIMIT}" if limit.blank? || limit < 1 || limit > MAX_LIMIT

        limit
      end

      def resource_params
        source = params[resource_param_key].presence || params

        source.permit(*permitted_attributes)
      end

      def resource_param_key
        model_class.model_name.param_key
      end

      def render_bad_request(error)
        render json: error_payload("bad_request", error.message), status: :bad_request
      end

      def render_not_found(error)
        render json: error_payload("not_found", error.message), status: :not_found
      end

      def render_unprocessable_entity(error)
        record = error.respond_to?(:record) ? error.record : nil
        details = record&.errors&.to_hash(true)
        message = details.present? ? "Validation failed" : error.message

        render json: error_payload("unprocessable_entity", message, details:), status: :unprocessable_entity
      end

      def error_payload(code, message, details: nil)
        payload = { error: { code:, message: } }
        payload[:error][:details] = details if details.present?
        payload
      end
    end
  end
end
