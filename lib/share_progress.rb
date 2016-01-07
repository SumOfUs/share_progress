require "share_progress/version"
require "share_progress/button"
require 'httparty'

module ShareProgress
  def self.configuration
    @configuration || Configuration.new
  end

  def self.configuration=(configuration)
    @configuration = configuration
  end

  def self.configure
    yield configuration
  end
end

class Configuration
  attr_accessor :share_progress_uri, :share_progress_api_key

  def initialize
    @share_progress_uri = ENV['SHARE_PROGRESS_URI'] || 'run.shareprogress.org/api/v1'
    @share_progress_api_key = ENV['SHARE_PROGRESS_API_KEY']
  end
end
