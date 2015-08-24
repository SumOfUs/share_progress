$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'share_progress'
require 'vcr'
require 'vcr/setup'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end