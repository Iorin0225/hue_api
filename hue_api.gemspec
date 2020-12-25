lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hue_api/version"

Gem::Specification.new do |spec|
  spec.name          = "hue_api"
  spec.version       = HueApi::VERSION
  spec.authors       = ["Iori OSADA"]
  spec.email         = ["iori.osada@gmail.com"]

  spec.summary       = "This gem manage requests and response of Philips Hue API"
  spec.description   = "This gem manage requests and response of Philips Hue API"
  spec.homepage      = "https://github.com/iorin0225/hue_app.git"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/master/blob/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"

  spec.add_dependency 'faraday', '~> 0.12.2'
  spec.add_dependency 'faraday_middleware', '~> 0.12.2'
end
