require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class EmailVariant < Variant
    attr_accessor :email_subject, :email_body

    def initialize(email_subject:, email_body:, button:)
      @email_subject = email_subject
      @email_body = email_body
      super(button)
    end

    def self.type
      'email'
    end

    private

    def fields
      [:email_subject, :email_body]
    end
  end
end
