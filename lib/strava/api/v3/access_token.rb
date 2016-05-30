require 'uri'
require 'net/http'
require 'multi_json'
require 'logger'
require 'strava/api/v3/errors'

module Strava
  module Api
    module V3
      class AccessToken
        OAUTH_TOKEN_URL = 'https://www.strava.com/oauth/token'

        def initialize(options = {})
          @client_id = options[:client_id]
          @client_secret = options[:client_secret]
          @code = options[:code]
        end

        def exchange
          response = post_request

          access_token_from_response(response.body)
        rescue Net::HTTPBadRequest
          ClientError.new(response.code, response.body)
        rescue Net::HTTPUnauthorized
          AuthenticationError.new(response.code, response.body)
        end

        private

        def access_token_from_response(response)
          json_body = MultiJson.load(response)

          if json_body.has_key?('access_token')
            json_body['access_token']
          else
            KeyError.new
          end
        end

        def post_request
          Net::HTTP.post_form(oauth_token_uri, {
            client_id: @client_id,
            client_secret: @client_secret,
            code: @code })
        end

        def oauth_token_uri
          @oauth_token_uri ||= URI.parse(OAUTH_TOKEN_URL)
        end
      end
    end
  end
end