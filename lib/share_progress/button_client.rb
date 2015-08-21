require 'share_progress'

module ShareProgress
  class ButtonClient
    def initialize
      @connection = ShareProgress::ConnectionFactory.get_connection
    end

    def new
    end

    def update
    end

    def find(id)
      @connection.make_call endpoint('read'), 'get', { id: id }
    end

    def destroy(id)
      @connection.make_call endpoint('delete'), 'post', { id: id }
    end

    def all(options={})
      acceptable = [:offset, :limit]
      @connection.make_call endpoint, 'get', filter_keys(options, acceptable)
    end

    private

    def endpoint(method=nil)
      extension = method.nil? ? "" : "/#{method}"
      "/api/v1/buttons#{extension}"
    end

    def filter_keys(params, acceptable)
      params.select{ |key, _| acceptable.include? key }
    end

  end
end