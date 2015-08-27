require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class FacebookVariant < Variant
    attr_accessor :facebook_title, :facebook_thumbnail, :facebook_description

    def self.type
      'facebook'
    end

    def self.fields
      [:facebook_title, :facebook_description, :facebook_thumbnail]
    end
  end
end
