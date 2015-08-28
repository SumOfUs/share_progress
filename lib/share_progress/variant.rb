require 'share_progress'
require 'share_progress/client'
require 'share_progress/errors'
require 'share_progress/button'

module ShareProgress
  class Variant
    attr_accessor :button, :id
    attr_reader   :errors

    def initialize(params=nil)
      update_attributes(params) unless params.nil?
    end

    def to_s
      self.serialize.to_json
    end

    def save
      add_error('button', "can't be blank") and return false if @button.nil?
      add_error('button', "must have an id") and return false if @button.id.nil?

      response = Button.update(id: @button.id, variants: {type => [serialize]})
    end

    def serialize
      serialized = Hash.new
      all_fields.each do |field|
        serialized[field] = send(field)
      end
      serialized
    end

    def update_attributes(params)
      Utils.symbolize_keys(params).each_pair do |key, value|
        @button = value if key == :button
        next unless all_fields.include? key
        instance_variable_set("@#{key}", value)
      end
    end

    def all_fields
      self.class.fields + [:id]
    end

    def type
      self.class.type
    end

    def set_analytics(analytics:)
      # Thinking at the moment that it makes sense to keep this as a basic hash, though
      # we might need to extend its functionality down the road.
      @analytics = analytics
    end

    def analytics
      if @analytics
        @analytics
      else
        raise AnalyticsNotFound
      end
    end

    private

    def add_error(field, message)
      @errors ||= {}
      @errors[field.to_s] ||= []
      @errors[field.to_s].push(message)
    end

  end
end

