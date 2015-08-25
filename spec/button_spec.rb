require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'

describe ShareProgress::Button do

  let(:fake_key) { 'A Fake Key' }
  let(:base_params) { { key: ENV['SHARE_PROGRESS_API_KEY'] } }
  let(:base_uri) { ShareProgress::Client::base_uri }
  let(:id) { 15246 }
  let(:page_url) { "http://act.sumofus.org/sign/What_Fast_Track_Means_infographic/" }
  let(:button_template) { "sp_fb_large" }
  let(:base_fields) { [:page_url, :page_title, :button_template, :share_button_html, :is_active] }

  describe 'instance methods' do
    let(:basic_button) { ShareProgress::Button.new({}) }
    subject { basic_button }

    it { should respond_to :page_url }
    it { should respond_to :page_url= }
    it { should respond_to :button_template }
    it { should respond_to :button_template= }
    it { should respond_to :page_title }
    it { should respond_to :page_title= }
    it { should respond_to :share_button_html }
    it { should respond_to :share_button_html= }
    it { should respond_to :is_active }
    it { should respond_to :is_active= }
    it { should respond_to :id }
    it { should_not respond_to :id= }

    it { should respond_to :update_attributes }
    it { should respond_to :save }
  end

  describe 'class methods' do
    subject { ShareProgress::Button }

    it { should respond_to :all }
    it { should respond_to :find }
    it { should respond_to :destroy }
    it { should respond_to :create }
    it { should respond_to :update }
    it { should_not respond_to :endpoint }
    it { should_not respond_to :filter_keys }
    it { should_not respond_to :optional_keys }
    it { should_not respond_to :advanced_options_keys }

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

        it 'receives an array of Button instances with ids', :vcr do
          result = ShareProgress::Button.all
          expect(result).to be_instance_of Array
          result.each do |button|
            expect(button).to be_instance_of ShareProgress::Button
            expect(button.id).not_to be_nil
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
          expect{ ShareProgress::Button.find() }.to raise_error ArgumentError
        end
      end

      describe 'receiving data', :vcr do

        it 'returns an instance of button' do
          expect(ShareProgress::Button.find(id)).to be_instance_of ShareProgress::Button
        end

        it 'finds a button with the correct id' do
          expect(ShareProgress::Button.find(id).id).to eq id
        end

        it 'populates all the basic fields' do
          button = ShareProgress::Button.find(id)
          base_fields.each do |field|
            expect(button.send(field)).not_to be_nil
          end
        end

        it 'raises an ArgumentError when there is no button with that id' do
          expect{ ShareProgress::Button.find(999999999)}.to raise_error ArgumentError
        end

      end

    end

    describe 'create' do

      describe 'receiving data', :vcr do

        describe 'after submitting good params' do

          it 'returns an instance of button' do
            expect(ShareProgress::Button.create(page_url, button_template)).to be_instance_of ShareProgress::Button
          end

          it 'returns a button with the supplied params and an id' do
            button = ShareProgress::Button.create(page_url, button_template)
            expect(button.page_url).to eq page_url
            expect(button.button_template).to eq button_template
            expect(button.id).to be > 0
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
end
