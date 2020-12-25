module HueApi
  class Client
    attr_reader :endpoint,
                :username

    API_PATH = '/api/'

    def initialize
      @endpoint = ENV['ENDPOINT']
      @username = ENV['USERNAME']

      authorize unless authorized?
    end

    def authorized?
      request.authorized?
    end

    def load_resources
      response = @request.get_full_resources

      set_lights(response.body['lights'])
      set_groups(response.body['groups'])
      true
    end

    def load_lights
      response = @request.get_lights
      set_lights(response.body)
    end

    def set_lights(lights_response)
      lights = {}
      lights_response.each do |key, value|
        lights[key.to_i] = HueApi::Light.new(key, value, self)
      end

      @lights = lights
    end

    def lights
      @lights ||= load_lights
    end

    def light_names
      lights.values.map(&:name)
    end

    def find_light_by_name(light_name)
      lights.values.find{ |light| light.name == light_name}
    end

    def load_groups
      response = @request.get_groups
      set_groups(response.body)
    end

    def set_groups(groups_response)
      groups = {}
      groups_response.each do |key, value|
        groups[key.to_i] = HueApi::Group.new(key, value, self)
      end

      @groups = groups
    end

    def groups
      @groups ||= load_groups
    end

    def group_names
      groups.values.map(&:name)
    end

    def find_group_by_name(group_name)
      groups.values.find{ |group| group.name == group_name}
    end

    def load_scenes
      response = @request.get_scenes
      set_scenes(response.body)
    end

    def set_scenes(scenes_response)
      scenes = {}
      scenes_response.each do |key, value|
        scenes[key] = HueApi::Scene.new(key, value, self)
      end

      @scenes = scenes
    end

    def scenes
      @scenes ||= load_scenes
    end

    def scenes_group_map
      map = {}
      groups.values.each do |group|
        matched_scenes = []
        scenes.values.map do |scene|
          next unless scene.group_id == group.id
          matched_scenes.append({
            'id' => scene.id,
            'name' => scene.name
          })
        end

        map[group.name] = matched_scenes
      end

      map
    end

    def available_scenes(group_name)
      scenes_group_map[group_name]
    end

    def set_scene_to_group(group_name, scene_name)
      scene_hash = available_scenes(group_name).find{ |scene_map| scene_map['name'] == scene_name}
      find_group_by_name(group_name).set_scene(scene_hash['id'])
    end

    def request
      @request ||= HueApi::Request.new(bridge_endpoint: @endpoint, username: @username)
    end

    private

    def fetch_and_set_endpoint
      bridges = request.get_hue_bridges
      update_endpoint("http://#{bridges[0]['internalipaddress']}")
    end

    def authorize
      return if authorized?
      fetch_and_set_endpoint unless @endpoint

      response = request.create_user
      update_username(response.body.dig(0, 'success', 'username'))
    end

    def update_endpoint(endpoint)
      @endpoint               = endpoint
      ENV['ENDPOINT']         = endpoint
      request.bridge_endpoint = endpoint
    end

    def update_username(username)
      @username        = username
      ENV['USERNAME']  = username
      request.username = username
    end

  end
end
