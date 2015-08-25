require 'share_progress'
require 'share_progress/client'

module ShareProgress
  class Variation
    class << self
      def facebook_type_name
        'facebook'
      end

      def twitter_type_name
        'twitter'
      end

      def email_type_name
        'email'
      end

      def facebook_type
        FacebookVariation
      end

      def twitter_type
        TwitterVariation
      end

      def email_type
        EmailVariation
      end
    end

    def to_s
      self.compile_to_hash.to_json
    end

    def compile_to_hash
      # override this in variation subclasses
    end

    def save
      # this should bump off to the button that controls it to save, just haven't finished it yet
    end

    def set_analytics(analytics:)
      # this will be called by the parent button which is able to update the analytics for the variation.
    end
  end

  class FacebookVariation < Variation
    attr_accessor :facebook_title, :facebook_thumbnail, :facebook_description

    def initialize(facebook_title:, facebook_description:, facebook_thumbnail:)
      @facebook_title = facebook_title
      @facebook_description = facebook_description
      @facebook_thumbnail = facebook_thumbnail
    end

    def compile_to_hash
      {
          facebook_title: @facebook_title,
          facebook_description: @facebook_description,
          facebook_thumbnail: @facebook_thumbnail
      }
    end
  end

  class TwitterVariation < Variation
    attr_accessor :twitter_message

    def initialize(twitter_message:)
      @twitter_message = twitter_message
    end

    def compile_to_hash
      {twitter_message: @twitter_message}
    end
  end

  class EmailVariation < Variation
    attr_accessor :email_subject, :email_body

    def initialize(email_subject:, email_body:)
      @email_subject = email_subject
      @email_body = email_body
    end

    def compile_to_hash
      {email_subject: @email_subject, email_body: @email_body}
    end
  end
end

