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
        check_api_error(http_response)
        formatted = http_response['response'].nil? ? [] : http_response['response']
        errors = http_response['success'] ? {} : http_response['message']
        formatted.each { |r| r['errors'] = errors }
        formatted
      end

      def check_api_error(http_response)
        return if http_response.code < 300
        return if http_response.code == 404 || http_response.code == 422
        error_msg = "Status #{http_response.code}: #{http_response['message']}\n" +
                    "Requesting: #{http_response.request.uri.to_s}\n" +
                    "With Body: #{http_response.request.raw_body}"
        raise ApiError.new(error_msg)
      end

    end
  end
end
