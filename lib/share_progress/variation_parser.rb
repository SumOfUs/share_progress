require 'share_progress'
require 'share_progress/email_variation'
require 'share_progress/facebook_variation'
require 'share_progress/twitter_variation'

module ShareProgress
  class VariationParser
    def self.parse(hash_to_parse)
      key, _ = hash_to_parse.first
      [FacebookVariation, EmailVariation, TwitterVariation].each do |variation_type|
        if key.to_s.include? variation_type.type_name
          return variation_type
        end
      end
      nil
    end
  end
end
