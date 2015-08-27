require 'share_progress'
require 'share_progress/variant'

module ShareProgress
  class EmailVariant < Variant
    attr_accessor :email_subject, :email_body

    def self.type
      'email'
    end

    def self.fields
      [:email_subject, :email_body]
    end
  end
end
