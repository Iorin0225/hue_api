module HueApi
  class Request
    attr_accessor :bridge_endpoint,
                  :username

    DISCOVER_URL = 'https://discovery.meethue.com/'
    API_PATH = 'api'

    LINK_BUTTON_NOT_PRESSED_STR = 'link button not pressed'

    def initialize(bridge_endpoint: nil, username: nil)
      @bridge_endpoint = bridge_endpoint
      @username = username
    end

    def authorized?
      !!(@bridge_endpoint && @username)
    end

    def create_user
      return if @username

      response = request_api('', :post, {devicetype: 'my_hue_app#iorin0225'})
      raise 'Please press Link Button on the Hue Bridge.' if response.error_description == LINK_BUTTON_NOT_PRESSED_STR

      response
    end

    # ###############################
    # API Stuff
    # ###############################

    def get_hue_bridges
      response = Faraday.new(url: DISCOVER_URL) do |faraday|
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end.get
      raise 'Hue Discover service is down.' unless response.success?
      response.body
    end

    def get_full_resources
      request_api('', :get)
    end

    def get_lights
      request_api('lights', :get)
    end

    def get_light(light_id)
      request_api("lights/#{light_id}", :get)
    end

    def get_groups
      request_api('groups', :get)
    end

    def get_group(group_id)
      request_api("groups/#{group_id}", :get)
    end

    def change_light_state(light_id, state)
      request_api("lights/#{light_id}/state", :put, state)
    end

    def change_group_state(group_id, state)
      request_api("groups/#{group_id}/action", :put, state)
    end

    def get_scenes
      request_api('scenes', :get)
    end

    private

    # ###############################
    # Base Stuff
    # ###############################

    def api_path(path)
      [API_PATH, username, path].join('/')
    end

    def request_api(path, method, params = {})
      client = api_client
      response = client.send(method) do |req|
        req.url api_path(path)
        req.body = params.to_json unless params.nil?
      end
      raise FailedAPIError unless response.success?

      HueApi::Response.new(response)
    end

    def api_client
      Faraday.new(url: bridge_endpoint) do |faraday|
        faraday.request :json
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
