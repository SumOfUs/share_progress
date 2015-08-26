require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
  config.filter_sensitive_data("<API_KEY>") { ENV['SHARE_PROGRESS_API_KEY'] }
end
