require 'httparty'

module ShareProgress
  class Client
    include HTTParty

    base_uri 'run.shareprogress.org/api/v1'
    default_params key: ENV['SHARE_PROGRESS_API_KEY']

    class << self

      def get(*args)
        format_response(super(*args))
      end

      def post(*args)
        format_response(super(*args))
      end

      private

      def format_response(http_response)
        formatted = http_response['response'].nil? ? [] : http_response['response']
        errors = http_response['success'] ? {} : http_response['message']
        formatted.each { |r| r['errors'] = errors }
        formatted
      end

    end
  end
end
