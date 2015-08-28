require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class TwitterVariant < Variant

    def self.type
      'twitter'
    end

    def self.fields
      [:twitter_message]
    end

    attr_accessor *fields
  end
end
