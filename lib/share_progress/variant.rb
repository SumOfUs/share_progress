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

