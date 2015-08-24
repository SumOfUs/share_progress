require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'

describe ShareProgress do
  it 'has a version number' do
    expect(ShareProgress::VERSION).not_to be nil
  end
end
