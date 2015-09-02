require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class EmailVariant < Variant

    def self.type
      'email'
    end

    def self.fields
      [:email_subject, :email_body]
    end

    attr_accessor *fields
  end
end
