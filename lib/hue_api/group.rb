module HueApi
  class Group
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

    def light_ids
      @params['lights']
    end

    def change_state(state)
      @client.request.change_group_state(@id, state)
      reload
    end

    def set_scene(scene_id)
      change_state({scene: scene_id})
    end

    def turn_on
      any_on = state['any_on']
      change_state({on: !any_on})
    end

    def alert(type = 'select')
      change_state({alert: type})
    end

    def effect(type = 'none')
      change_state({effect: type})
    end

    def reload
      @params = @client.request.get_group(@id).body
    end
  end
end
