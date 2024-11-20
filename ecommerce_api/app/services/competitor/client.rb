require "faraday"

module Competitor
  class Client
    def initialize
      @config = Competitor::Configuration.new
      @conn = Faraday.new(url: @config.base_url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers["Content-Type"] = "application/json"
      end
    end

    def get(path, params = {})
      params.merge!(api_key: @config.api_key)

      response = http_request(:get, path, params)

      Competitor::Response.new(response).handle
    end

    private

    def http_request(method, path, params = {}, body = nil)
      @conn.send(method) do |req|
        req.url path.to_s
        req.params = params unless params.empty?
        req.body = body.to_json if body
      end
    end
  end
end
