module Competitor
  class Configuration
    attr_accessor :api_key
    attr_reader :base_url

    def initialize
      @api_key = ENV["COMPETITOR_API_KEY"]
      @base_url = ENV["COMPETITOR_PRICING_API"]
    end
  end
end
