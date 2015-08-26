require 'share_progress'
require 'share_progress/client'
require 'share_progress/errors'

module ShareProgress
  class Variation
    attr_accessor :button

    def initialize(button)
      @button = button
    end

    class << self
      def facebook_type_name
        'facebook'
      end

      def twitter_type_name
        'twitter'
      end

      def email_type_name
        'email'
      end

      def type_name
        'variation'
      end
    end

    def to_s
      self.compile_to_hash.to_json
    end

    def compile_to_hash
      # override this in variation subclasses
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

