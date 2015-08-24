require 'share_progress'
require 'share_progress/client'

module ShareProgress
  class Button

    attr_accessor :id, :page_url, :page_title, :button_template, :share_button_html, :is_active

    class << self

      def create(page_url, button_template, raw_options={})
        created = update(nil, page_url, button_template, raw_options)
        created.nil? ? nil : new_from_fields(created)
      end

      # this method is used by instance.save and Button.create
      def update(id, page_url, button_template, raw_options={})
        options = filter_keys(raw_options, optional_keys)
        options[:advanced_options] = filter_keys(options[:advanced_options], advanced_options_keys)
        options = options.merge({page_url: page_url, button_template: button_template})
        options[:id] = id unless id.nil? # without ID, update is create
        created = Client.post endpoint('update'), { body: options }
        created[0]
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
        return params if params.nil?
        params.select{ |key, _| acceptable.include? key }
      end

      def new_from_fields(fields)
        new(fields['id'],
            fields['page_url'],
            fields['button_template'],
            fields['page_title'],
            fields['share_button_html'],
            fields['is_active'])
      end

      def optional_keys
        [:page_title, :auto_fill, :variations, :advanced_options]
      end

      def advanced_options_keys
        [:automatic_traffic_routing, :buttons_optimize_actions, :custom_params, :prompt]
      end
    end

    def initialize(id, page_url, button_template, page_title, share_button_html, is_active)
      self.id = id
      self.page_url = page_url
      self.button_template = button_template
      self.page_title = page_title
      self.share_button_html = share_button_html
      self.is_active = is_active
    end

    def save
      other_fields = {page_title: page_title, share_button_html: share_button_html, is_active: is_active}
      result = self.class.update(id, page_url, button_template, other_fields)
      # need to update parameters based on result
      (result.size > 0)
    end

  end
end
