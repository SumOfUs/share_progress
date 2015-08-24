require 'httparty'

module ShareProgress
  class Client
    include HTTParty

    base_uri 'run.shareprogress.org/api/v1'
    default_params key: ENV['SHARE_PROGRESS_API_KEY']
  end
end
