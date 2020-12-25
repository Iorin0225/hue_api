module HueApi
  class Scene
    attr_reader :id, :params

    def initialize(id, params, client)
      @id = id
      @params = params
      @client = client
    end

    def name
      @params['name']
    end

    def type
      @params['type']
    end

    def group_id
      @params['group']
    end
  end
end
