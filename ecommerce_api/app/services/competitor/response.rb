module Competitor
  class Response
    attr_reader :body, :status

    def initialize(response_body)
      @response_body = response_body
      @body = response_body.body
      @status = response_body.status
    end

    def handle
      return self if @response_body.success?

      case status
      when 422
        raise Competitor::ClientError, "Unprocessable Content: #{@body}"
      when 500
        raise Competitor::ServerError, "Internal Server Error: #{@body}"
      else
        raise Competitor::UnexpectedResponseError, "Unexpected Response: #{@status}"
      end
    end

    def data
      JSON.parse(@body, symbolize_names: true)
    end
  end

  class ClientError < StandardError; end
  class ServerError < StandardError; end
  class UnexpectedResponseError < StandardError; end
end
