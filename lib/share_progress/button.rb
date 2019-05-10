require 'share_progress'
require 'share_progress/client'
require 'share_progress/utils'
require 'share_progress/errors'
require 'share_progress/variant_collection'

module ShareProgress
  class Button

    attr_accessor :page_url, :page_title, :button_template, :share_button_html, :is_active, :auto_fill, :variants, :advanced_options, :include, :id
    attr_reader   :errors

    class << self

      def create(page_url:, button_template:, **options)
        created = update(options.merge(page_url: page_url, button_template: button_template))
        created.nil? ? new({}) : new(created)
      end

      # this method is used by instance.save and Button.create
      def update(options={})
        Utils.filter_keys(options, allowed_keys)
        Utils.filter_keys(options[:advanced_options], advanced_options_keys)
        created = Client.post endpoint('update'),
          body: options.to_json,
          headers: { 'content-type': 'application/json' }
        created[0] # the API returns a list of length 1
      end

      def find(id)
        matches = Client.get endpoint('read'), { query: { id: id } }
        raise RecordNotFound.new("No button exists with id #{id}") if matches.size < 1
        new(matches[0])
      end

      def destroy(id)
        deleted = Client.post endpoint('delete'),
          body: { id: id }.to_json,
          headers: { 'content-type': 'application/json' }
        (deleted.size > 0)
      end

      def all(limit: 100, offset: 0)
        matches = Client.get endpoint, { query: { limit: limit, offset: offset } }
        matches.map{ |match| new(match) }
      end

      def allowed_keys
        optional_keys + required_keys
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
        [:id, :page_title, :auto_fill, :variants, :advanced_options, :share_button_html, :is_active, :errors]
      end

      def advanced_options_keys
        [:automatic_traffic_routing, :buttons_optimize_actions, :custom_params, :prompt]
      end
    end

    def initialize(params)
      @variant_collection = VariantCollection.new
      update_attributes(params)
    end

    def update_attributes(params)
      params = Utils.symbolize_keys(params)
      params.each_pair do |key, value|
        instance_variable_set("@#{key}", value) unless key == :variants
      end
      self.variants = params[:variants] if params.include? :variants
    end

    def save
      result = self.class.update(serialize)
      update_attributes(result)
      (errors.size == 0)
    end

    def variants=(variants)
      @variant_collection.update_variants(variants)
    end

    def variants
      @variant_collection.serialize
    end

    def add_or_update_variant(variant)
      @variant_collection.add_or_update(variant)
    end

    def remove_variant(variant)
      @variant_collection.remove(variant)
    end

    def find_variant(variant)
      @variant_collection.find(variant)
    end

    def destroy
      self.class.destroy(id) ? self : false
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
