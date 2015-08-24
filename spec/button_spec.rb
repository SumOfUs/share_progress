require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'

describe ShareProgress::Button do

  let(:fake_key) { 'A Fake Key' }
  let(:base_params) { { api_key: ENV['SHARE_PROGRESS_API_KEY'] } }
  let(:base_uri) { ShareProgress::Client::base_uri }
  let(:id) { 25 }

  describe 'all' do

    let(:uri) { base_uri + '/buttons' }

    describe 'making requests' do

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

    describe 'receiving data' do

      it 'gets empty JSON when none created', :vcr do
        expect(ShareProgress::Button.all).to eq Hash.new
      end

    end
  end

  describe 'find' do

    let(:uri) { base_uri + '/buttons/read' }

    it 'requests the read action with an id' do
      params = base_params.merge({id: id})
      stub_request(:get, uri).with(query: params)
      ShareProgress::Button.find(id)
      expect(WebMock).to have_requested(:get, uri).with(query: params)
    end

    it 'raises an error without an id' do
      expect{ ShareProgress::Button.find() }.to raise_error(ArgumentError)
    end
  end

  describe 'destroy' do

    let(:uri) { base_uri + '/buttons/delete' }

    it 'posts to the delete action with an id' do
      params = base_params.merge({id: id})
      stub_request(:post, uri).with(query: params)
      ShareProgress::Button.destroy(id)
      expect(WebMock).to have_requested(:post, uri).with(query: params)
    end

    it 'raises an error without an id' do
      expect{ ShareProgress::Button.destroy() }.to raise_error(ArgumentError)
    end
  end
end
