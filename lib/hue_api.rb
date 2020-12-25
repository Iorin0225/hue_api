require 'faraday'
require 'faraday_middleware'
require "hue_api/version"
require "hue_api/client"
require "hue_api/request"
require "hue_api/response"
require "hue_api/light"
require "hue_api/group"
require "hue_api/scene"

module HueApi
  class Error < StandardError; end
  class NotUnthorizedError < Error; end
  class FailedAPIError < Error; end
end
