require 'share_progress'
require 'share_progress/email_variant'
require 'share_progress/facebook_variant'
require 'share_progress/twitter_variant'

module ShareProgress
  class VariantParser
    def self.parse(hash_to_parse)
      key, _ = hash_to_parse.first
      [FacebookVariant, EmailVariant, TwitterVariant].each do |variant_type|
        if key.to_s.include? variant_type.type
          return variant_type
        end
      end
      nil
    end
  end
end
