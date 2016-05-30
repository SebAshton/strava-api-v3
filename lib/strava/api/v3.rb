require "strava/api/v3/version"
require "strava/api/v3/configuration"
require "strava/api/v3/client"
require "strava/api/v3/token"

module Strava
  module Api
    module V3
      extend Configuration
      include Token
    end
  end
end
