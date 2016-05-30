require 'uri'
require 'net/http'
require 'multi_json'

module Strava
  module Api
    module V3
      module Token
        OAUTH_TOKEN_URL = 'https://www.strava.com/oauth/token'

        def exchange_code_for_access_token(client_id, client_secret, code)
          response = post_request(client_id, client_secret, code)

          access_token_from_response(response.body)
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

        def post_request(client_id, client_secret, code)
          Net::HTTP.post_form(oauth_token_uri, {
            client_id: client_id,
            client_secret: client_secret,
            code: code })
        end

        def oauth_token_uri
          @oauth_token_uri ||= URI.parse(OAUTH_TOKEN_URL)
        end
      end
    end
  end
end