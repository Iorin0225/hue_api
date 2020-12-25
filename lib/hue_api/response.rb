module HueApi
  class Response
    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def body
      @response.body
    end

    def success?
      @response.success? && body.dig(0).keys.include?('success')
    end

    def error_description
      body.dig(0, 'error', 'description')
    end
  end
end
