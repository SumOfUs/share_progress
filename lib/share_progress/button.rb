require 'share_progress'
require 'share_progress/client'
require 'share_progress/utils'

module ShareProgress
  class Button

    attr_accessor :page_url, :page_title, :button_template, :share_button_html, :is_active, :auto_fill, :variations, :advanced_options
    attr_reader   :id, :errors

    class << self

      def create(options={})
        created = update(options)
        created.nil? ? new({}) : new(created)
      end

      # this method is used by instance.save and Button.create
      def update(options={})
        Utils.filter_keys(options, allowed_keys)
        Utils.filter_keys(options[:advanced_options], advanced_options_keys)
        created = Client.post endpoint('update'), { body: options }
        created[0] # the API returns a list of length 1
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

      def allowed_keys
        required_keys + optional_keys
      end

      private

      def endpoint(method=nil)
        extension = method.nil? ? "" : "/#{method}"
        "/buttons#{extension}"
      end

      # currently no validation, but worth noting that they're different
      def required_keys
        [:page_url, :button_template]
      end

      def optional_keys
        [:id, :page_title, :auto_fill, :variations, :advanced_options, :is_active, :share_button_html, :errors]
      end

      def advanced_options_keys
        [:automatic_traffic_routing, :buttons_optimize_actions, :custom_params, :prompt]
      end
    end

    def initialize(params)
      update_attributes(params)
    end

    def update_attributes(params)
      params.each_pair do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def save
      result = self.class.update(serialize)
      update_attributes(result)
      (errors.size == 0)
    end

    private

    def serialize
      serialized = Hash.new
      self.class.allowed_keys.each do |key|
        value = send(key)
        serialized[key] = value unless value.nil?
      end
      serialized
    end

  end
end
