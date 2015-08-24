require 'httparty'

module ShareProgress
  class Client
    include HTTParty

    base_uri 'run.shareprogress.org/api/v1'
    default_params key: ENV['SHARE_PROGRESS_API_KEY']

    class << self

      def get(*args)
        response_field(super(*args))
      end

      def post(*args)
        response_field(super(*args))
      end

      private

      def response_field(http_response)
        http_response['response'].nil? ? [] : http_response['response']
      end

    end
  end
end
