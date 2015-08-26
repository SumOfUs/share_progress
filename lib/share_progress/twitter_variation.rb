require 'share_progress'
require 'share_progress/variation'

module ShareProgress
  class TwitterVariation < Variation
    attr_accessor :twitter_message

    def initialize(twitter_message:, button:)
      @twitter_message = twitter_message
      super(button)
    end

    def compile_to_hash
      {twitter_message: @twitter_message}
    end

    def self.type_name
      Variation.twitter_type_name
    end
  end
end
