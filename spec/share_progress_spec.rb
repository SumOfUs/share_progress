require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'

describe ShareProgress do
  let(:base_uri) { 'http://run.shareprogress.org' }

  before(:each) do
    ENV['API_KEY'] = 'A Fake Key'
  end

  it 'has a version number' do
    expect(ShareProgress::VERSION).not_to be nil
  end

  it 'can handle all the HTTP types' do
    types = [:get, :post, :put, :patch, :delete]
    types.each do |type|
      stub_request(type, base_uri + '/')
      ShareProgress::ConnectionFactory.get_connection.make_call '/', type.to_s, {}
      expect(WebMock).to have_requested(type, base_uri + '/')
    end
  end

  it 'has the API key in the body' do
    stub_request(:get, base_uri + '/')
    ShareProgress::ConnectionFactory.get_connection.make_call '/', 'get', {}
    expect(WebMock).to have_requested(:get, base_uri + '/').with(body: {api_key: ENV['API_KEY']})
  end
end
