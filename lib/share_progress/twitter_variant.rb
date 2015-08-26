require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class TwitterVariant < Variant
    attr_accessor :twitter_message

    def initialize(twitter_message:, button:)
      @twitter_message = twitter_message
      super(button)
    end

    def compile_to_hash
      {twitter_message: @twitter_message}
    end

    def self.type
      'twitter'
    end
  end
end
