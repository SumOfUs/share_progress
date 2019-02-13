module ShareProgress
  def self.configuration
    @config || Configuration.new
  end

  def self.configuration=(configuration)
    @config = configuration
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :share_progress_uri, :share_progress_api_key

    def initialize
      @share_progress_uri = 'https://run.shareprogress.org/api/v1'
      @share_progress_api_key = ENV['SHARE_PROGRESS_API_KEY'] || 'please_set_an_api_key'
    end
  end
end
