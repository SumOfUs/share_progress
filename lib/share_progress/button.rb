require 'share_progress'
require 'share_progress/client'

module ShareProgress
  class Button

    attr_accessor :page_url, :page_title, :button_template, :share_button_html, :is_active
    attr_reader   :id

    class << self

      def create(page_url, button_template, raw_options={})
        created = update(nil, page_url, button_template, raw_options)
        created.nil? ? nil : new(created)
      end

      # this method is used by instance.save and Button.create
      def update(id, page_url, button_template, options={})
        filter_keys(options, optional_keys)
        filter_keys(options[:advanced_options], advanced_options_keys)
        options = options.merge({page_url: page_url, button_template: button_template})
        options[:id] = id unless id.nil? # without ID, update is create
        created = Client.post endpoint('update'), { body: options }
        created[0]
      end

      def find(id)
        matches = Client.get endpoint('read'), { query: { id: id } }
        raise ArgumentError.new("No button exists with id #{id}") if matches.size < 1
        new(matches[0])
      end

      def destroy(id)
        Client.post endpoint('delete'), { query: { id: id } }
      end

      def all(limit: 100, offset: 0)
        matches = Client.get endpoint, { query: { limit: limit, offset: offset } }
        matches.map{ |match| new(match) }
      end

      private

      def endpoint(method=nil)
        extension = method.nil? ? "" : "/#{method}"
        "/buttons#{extension}"
      end

      def filter_keys(params, acceptable)
        return params if params.nil?
        params.select!{ |key, _| acceptable.include? key }
      end

      def optional_keys
        [:page_title, :auto_fill, :variations, :advanced_options]
      end

      def advanced_options_keys
        [:automatic_traffic_routing, :buttons_optimize_actions, :custom_params, :prompt]
      end
    end

    def initialize(params)
      update_attributes(params)
    end

    def update_attributes(params)
      @id = params['id'] if params.include? 'id'
      self.page_url = params['page_url'] if params.include? 'page_url'
      self.is_active = params['is_active'] if params.include? 'is_active'
      self.page_title = params['page_title'] if params.include? 'page_title'
      self.button_template = params['button_template'] if params.include? 'button_template'
      self.share_button_html = params['share_button_html'] if params.include? 'share_button_html'
    end

    def save
      other_fields = {page_title: page_title, share_button_html: share_button_html, is_active: is_active}
      result = self.class.update(id, page_url, button_template, other_fields)
      # need to update parameters based on result
      (result.size > 0)
    end

  end
end
