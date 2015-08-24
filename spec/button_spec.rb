require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'

describe ShareProgress::Button do

  let(:fake_key) { 'A Fake Key' }
  let(:base_params) { { api_key: ENV['API_KEY'] } }
  let(:base_uri) { ShareProgress::Client::base_uri }

  describe 'all' do

    let(:uri) { base_uri + '/buttons' }

    after :each do
      params = base_params.merge(@request_params)
      stub_request(:get, uri).with(query: params)
      ShareProgress::Button.all(@method_params)
      expect(WebMock).to have_requested(:get, uri).with(query: params)
    end

    it 'requests the index action' do
      @request_params = {}
      @method_params  = {}
    end

    it 'requests the index action with limit and offset params' do
      @method_params = {limit: 5, offset: 20}
      @request_params = @method_params
    end

    it 'requests the index action without unknown params' do
      @method_params = {fake_param: 10}
      @request_params = {}
    end
  end
end
