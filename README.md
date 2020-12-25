# HueApi

This manage Philips Hue Lights (and a Bridge) using their REST API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hue_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hue_api

## Usage

NOTE: Before use this, you need to join same network with your Hue Bridge.

### 1. Initializing

This has a client to manage whole things. 

At first time you would faile the creating client with this error. 

```rb
> client = HueApi::Client.new
RuntimeError: Please press Link Button on the Hue Bridge.
```

It's because of Hue's security system. The Hue Bridge does not allow other's access at normal. You can open the block just one time with pressing the Link Button on the Bridge

So, as the message said, please press the link button on your bridge.
And then, the client can connect with your bridge.

```rb
# This would success after pressing link button.
> client = HueApi::Client.new
=> #<HueApi::Client:...
```

### 2. Load resources

You can collect all resources which connecting with the bridge with `client.load_resources`.

```rb
> client.load_resources
=> true
```

And then it's ready to use.

### 3. See resources

Hue API's data is a bit difficult for human to read because it uses some IDs and we can't see it on Official Philips Hue App.
`HueApi::Client` has some functions to see the resources easily.

```rb
> client.light_names
=>  ["Hue color lamp 1", "Hue color lamp 2", "Hue color lamp 3"]

> client.group_names
=> ["living room", "kids room"]

> client.find_light_by_name('Hue color lamp 1')
=> #<HueApi::Light:...

> client.find_group_by_name('living room')
=> #<HueApi::Group:...

> client.client.scenes_group_map  
=> {"living room"=>
  [{"id"=>"vQFvInRgWiCDumj", "name"=>"Savanna sunset"},
   {"id"=>"crHSbP0PrrJ8SuI", "name"=>"Tropical twilight"},
   {"id"=>"KgyZoIzmXlSta3s", "name"=>"Arctic aurora"},
   ...

> client.available_scenes('living room')
=> [{"id"=>"vQFvInRgWiCDumj", "name"=>"Savanna sunset"},
 {"id"=>"crHSbP0PrrJ8SuI", "name"=>"Tropical twilight"},
 {"id"=>"KgyZoIzmXlSta3s", "name"=>"Arctic aurora"},

```

### 3. Change the state of the light/group

`HueApi::Client`, `HueApi::Light` and `HueApi::Group` has some functions to change its state easily.

```rb

# Set Scene by name
> client.set_scene_to_group('living room', 'Spring blossom')

# Change Light's state with name
> client.find_light_by_name('Hue color lamp 1').turn_on
> client.find_light_by_name('Hue color lamp 1').alert
> client.find_light_by_name('Hue color lamp 1').effect('colorloop')

# Change Group's state with name
> client.find_group_by_name('living room').turn_on
> client.find_group_by_name('living room').alert
> client.find_group_by_name('living room').effect('colorloop')


```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/hue_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HueApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/hue_api/blob/master/CODE_OF_CONDUCT.md).
