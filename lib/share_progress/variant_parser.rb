require 'share_progress'
require 'share_progress/errors'
require 'share_progress/email_variant'
require 'share_progress/facebook_variant'
require 'share_progress/twitter_variant'

module ShareProgress
  class VariantParser

    def self.parse(hash_to_parse)
      keys = hash_to_parse.keys.map(&:to_sym)
      match = nil
      [FacebookVariant, EmailVariant, TwitterVariant].each do |variant_class|
        if (keys & variant_class.fields).size > 0 # & is array intersection
          raise CouldNotParseVariant unless match.nil? # only match one class
          match = variant_class
        end
      end
      raise CouldNotParseVariant if match.nil?
      match
    end

  end
end
