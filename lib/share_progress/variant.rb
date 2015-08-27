require 'share_progress'
require 'share_progress/client'
require 'share_progress/errors'

module ShareProgress
  class Variant
    attr_accessor :button, :id

    def initialize(button)
      @button = button
    end

    def to_s
      self.compile_to_hash.to_json
    end

    def compile_to_hash
      # override this in variant subclasses
    end

    def save
      @button.update
    end

    def compile_to_hash
      serialized = Hash.new
      all_fields.each do |field|
        serialized[field] = send(field)
      end
      serialized
    end

    def update_attributes(params)
      Utils.symbolize_keys(params).each_pair do |key, value|
        next unless all_fields.include? key
        instance_variable_set("@#{key}", value)
      end
    end

    def all_fields
      fields + [:id]
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
  end
end

