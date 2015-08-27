require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class FacebookVariant < Variant
    attr_accessor :facebook_title, :facebook_thumbnail, :facebook_description

    def initialize(facebook_title:, facebook_description:, facebook_thumbnail:, button:)
      @facebook_title = facebook_title
      @facebook_description = facebook_description
      @facebook_thumbnail = facebook_thumbnail
      super(button)
    end

    def self.type
      'facebook'
    end

    private

    def fields
      [:facebook_title, :facebook_description, :facebook_thumbnail]
    end
  end
end
