require 'share_progress'
require 'share_progress/client'

module ShareProgress
  class Button

    attr_accessor :id, :page_url, :page_title, :button_template, :share_button_html, :is_active

    class << self
      def create
      end

      def update
      end

      def find(id)
        matches = Client.get endpoint('read'), { query: { id: id } }
        raise ArgumentError.new("No button exists with id #{id}") if matches.size < 1
        new_from_fields(matches[0])
      end

      def destroy(id)
        Client.post endpoint('delete'), { query: { id: id } }
      end

      def all(options={})
        acceptable = [:offset, :limit]
        matches = Client.get endpoint, { query: filter_keys(options, acceptable) }
        matches.map{ |match| new_from_fields(match) }
      end

      private

      def endpoint(method=nil)
        extension = method.nil? ? "" : "/#{method}"
        "/buttons#{extension}"
      end

      def filter_keys(params, acceptable)
        params.select{ |key, _| acceptable.include? key }
      end

      def new_from_fields(fields)
        new(fields['id'],
            fields['page_url'],
            fields['page_title'],
            fields['button_template'],
            fields['share_button_html'],
            fields['is_active'])
      end
    end

    def initialize(id, page_url, page_title, button_template, share_button_html, is_active)
      self.id = id
      self.page_url = page_url
      self.page_title = page_title
      self.button_template = button_template
      self.share_button_html = share_button_html
      self.is_active = is_active
    end

  end
end
