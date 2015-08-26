require 'share_progress'
require 'share_progress/variation'

module ShareProgress
  class EmailVariation < Variation
    attr_accessor :email_subject, :email_body

    def initialize(email_subject:, email_body:, button:)
      @email_subject = email_subject
      @email_body = email_body
      super(button)
    end

    def compile_to_hash
      {email_subject: @email_subject, email_body: @email_body}
    end

    def self.type_name
      Variation.email_type_name
    end
  end
end
