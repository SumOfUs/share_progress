require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'

describe ShareProgress::Button do

  let(:fake_key) { 'A Fake Key' }
  let(:base_params) { { key: ENV['SHARE_PROGRESS_API_KEY'] } }
  let(:base_uri) { ShareProgress::Client::base_uri }
  let(:id) { 15246 }

  describe 'all' do

    let(:index_base_params) { base_params.merge({limit: 100, offset: 0}) }
    let(:uri) { base_uri + '/buttons' }

    describe 'making requests' do

      after :each do
        params = index_base_params.merge(@request_params)
        stub_request(:get, uri).with(query: params)
        ShareProgress::Button.all(**@method_params)
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
    end

    it 'raises an error when passed a wrong param' do
      expect{ ShareProgress::Button.all(fake_param: 10) }.to raise_error ArgumentError
    end

    describe 'receiving data', :vcr do

      it 'receives an array of Button instances', :vcr do
        result = ShareProgress::Button.all
        expect(result).to be_instance_of Array
        result.each do |button|
          expect(button).to be_instance_of ShareProgress::Button
        end
      end

    end
  end

  describe 'find' do

    let(:uri) { base_uri + '/buttons/read' }

    describe 'making requests' do

      it 'requests the read action with an id' do
        params = base_params.merge({id: id})
        stub_request(:get, uri).with(query: params)
        expect{ ShareProgress::Button.find(id) }.to raise_error # record not found error
        expect(WebMock).to have_requested(:get, uri).with(query: params)
      end

      it 'raises an error without an id' do
        expect{ ShareProgress::Button.find() }.to raise_error(ArgumentError)
      end
    end

    describe 'receiving data', :vcr do

      it 'returns an instance of button' do
        expect(ShareProgress::Button.find(id)).to be_instance_of ShareProgress::Button
      end

    end

  end

  describe 'create' do

    let(:page_url) { "http://act.sumofus.org/sign/What_Fast_Track_Means_infographic/" }
    let(:button_template) { "sp_fb_large" }

    describe 'receiving data', :vcr do

      describe 'after submitting good params' do
        it 'returns an instance of button' do
          expect(ShareProgress::Button.create(page_url, button_template)).to be_instance_of ShareProgress::Button
        end
      end

      describe 'after submitting bad params' do

        it 'returns nil' do
          expect(ShareProgress::Button.create(nil, nil)).to eq nil
        end
      end

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
