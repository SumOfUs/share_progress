require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'

describe ShareProgress::ButtonClient do

  let(:fake_key) { 'A Fake Key' }
  let(:base_params) { { api_key: fake_key } }
  let(:base_uri) { ShareProgress::Connection::base_uri }
  let(:button)   { ShareProgress::ButtonClient.new }

  before(:each) do
    ENV['API_KEY'] = fake_key
  end

  describe 'all' do

    let(:uri) { base_uri + '/api/v1/buttons' }

    before :each do
      stub_request(:get, uri)
    end

    after :each do
      expect(WebMock).to have_requested(:get, uri).with(body: base_params.merge(@params))
    end

    it 'requests the index action' do
      @params = {}
      button.all
    end

    it 'requests the index action with limit and offset params' do
      @params = {limit: 5, offset: 20}
      button.all(@params)
    end

    it 'requests the index action without unknown params' do
      @params = {}
      button.all({fake_param: 10})
    end
  end
end
