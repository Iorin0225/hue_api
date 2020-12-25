module HueApi
  class Light
    attr_reader :id, :params

    def initialize(id, params, client)
      @id = id
      @params = params
      @client = client
    end

    def name
      @params['name']
    end

    def state
      @params['state']
    end

    def change_state(state)
      @client.request.change_light_state(@id, state)
      reload
    end

    def turn_on
      on = state['on']
      change_state({on: !on})
      reload
    end

    def alert(type = 'select')
      change_state({alert: type})
    end

    def effect(type = 'none')
      change_state({effect: type})
    end

    def reload
      @params = @client.request.get_light(@id).body
    end
  end
end
