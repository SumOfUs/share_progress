require 'share_progress'
require 'share_progress/client'

module ShareProgress
  class Button

    class << self
      def create
      end

      def update
      end

      def find(id)
        Client.get endpoint('read'), { query: { id: id } }
      end

      def destroy(id)
        Client.post endpoint('delete'), { query: { id: id } }
      end

      def all(options={})
        acceptable = [:offset, :limit]
        Client.get endpoint, { query: filter_keys(options, acceptable) }
      end

      private

      def endpoint(method=nil)
        extension = method.nil? ? "" : "/#{method}"
        "/buttons#{extension}"
      end

      def filter_keys(params, acceptable)
        params.select{ |key, _| acceptable.include? key }
      end
    end

  end
end
