require "share_progress/version"
require "share_progress/button"
require 'httparty'

module ShareProgress
  class ConnectionFactory
    def self.get_connection
      if @connection.nil?
        @connection = ShareProgress::Connection.new ENV['API_KEY']
      end
      @connection
    end
  end

  private
  class Connection
    include HTTParty
    base_uri 'run.shareprogress.org'

    def initialize(api_key)
      @api_key = api_key
    end

    def make_call(endpoint, method, parameters)

      # Include the API key in the parameters we're sending to SP.
      options = {body: parameters.merge({:api_key => @api_key})}

      # Call the HTTP method requested by the calling method.
      case method.downcase
        when 'get'
          self.class.get endpoint, options
        when 'post'
          self.class.post endpoint, options
        when 'put'
          self.class.put endpoint, options
        when 'delete'
          self.class.delete endpoint, options
        when 'patch'
          self.class.patch endpoint, options
        else
          self.class.get endpoint, options
      end
    end
  end
end
