require 'httparty'

module ShareProgress
  class Client
    include HTTParty
    debug_output $stdout if ENV['SHARE_PROGRESS_LOG_REQUESTS']

    base_uri ShareProgress.configuration.share_progress_uri
    default_params key: ShareProgress.configuration.share_progress_api_key

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
