require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class FacebookVariant < Variant

    def self.type
      'facebook'
    end

    def self.fields
      [:facebook_title, :facebook_description, :facebook_thumbnail]
    end

    attr_accessor *fields
  end
end
