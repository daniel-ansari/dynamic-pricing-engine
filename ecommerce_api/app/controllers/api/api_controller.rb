module API
  class APIController < ActionController::API
    include Paginatable

    rescue_from Mongoid::Errors::DocumentNotFound,        with: :render_not_found
    rescue_from Mongoid::Errors::InvalidFind,             with: :render_record_invalid
    rescue_from ActionController::ParameterMissing,       with: :render_parameter_missing

    private

      def render_not_found(exception)
        render_error(exception, { message: "The record is not found." }, :not_found)
      end

      def render_record_invalid(exception)
        render_error(exception, "The record must be exist.", :bad_request)
      end

      def render_parameter_missing(exception)
        render_error(exception, exception.message, :unprocessable_entity)
      end

      def render_error(exception, errors, status)
        logger.info { exception }
        render json: { errors: Array.wrap(errors) }, status:
      end
  end
end
