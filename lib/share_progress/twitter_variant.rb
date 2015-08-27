require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class TwitterVariant < Variant
    attr_accessor :twitter_message

    def self.type
      'twitter'
    end

    def self.fields
      [:twitter_message]
    end
  end
end
