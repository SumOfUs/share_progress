require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'
require 'httparty'

describe ShareProgress::Button do

  let(:fake_key) { 'A Fake Key' }
  let(:base_params) { { key: ENV['SHARE_PROGRESS_API_KEY'] } }
  let(:base_uri) { ShareProgress::Client::base_uri }
  let(:id) { 15246 }
  let(:page_url) { "http://act.sumofus.org/sign/What_Fast_Track_Means_infographic/" }
  let(:button_template) { "sp_fb_large" }
  let(:auto_variants) { {"facebook" => [{"id" => 62899,"facebook_title" => nil,"facebook_description" => nil,"facebook_thumbnail" => nil}],"email" => [{"id" => 62898,"email_subject" => nil,"email_body" => nil}],"twitter" => [{"id" => 62897,"twitter_message" => nil}]} }
  let(:base_fields) { [:page_url, :page_title, :button_template, :share_button_html, :is_active, :errors] }

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
    it { should respond_to :variations }
    it { should respond_to :variations= }
    it { should respond_to :advanced_options }
    it { should respond_to :advanced_options= }
    it { should respond_to :id }
    it { should_not respond_to :id= }
    it { should respond_to :errors }
    it { should_not respond_to :errors= }

    it { should respond_to :update_attributes }
    it { should respond_to :save }

    describe 'update_attributes' do

      let(:targets) { Hash.new }

      [:to_s, :to_sym].each do |type|

        describe "with #{type == :to_s ? 'string' : 'symbol'} keys" do

          describe 'can update all base attributes' do

            before :each do
              base_fields.each { |field| targets[field.send(type)] = field.to_s }
              basic_button.update_attributes(targets)
              targets.each_pair do |field, value|
                expect(basic_button.send(field.to_sym)).to eq value
              end
            end

            it 'to strings' do
            end

            # they need to be not nil first
            it 'to nil' do
              base_fields.each { |field| targets[field.send(type)] = nil }
              basic_button.update_attributes(targets)
              targets.each_pair do |field, value|
                expect(basic_button.send(field.to_sym)).to eq nil
              end
            end
          end

          it 'can update id' do
            basic_button.update_attributes({'id'.send(type) => 12345})
            expect(basic_button.id).to eq 12345
          end

          it 'cannot read fake keys' do
            basic_button.update_attributes({'fake_key'.send(type) => 12345})
            expect{ basic_button.fake_key }.to raise_error NoMethodError
          end
        end
      end

      describe 'with variants' do

        it "creates the variations list if it doesn't exist" do
          expect(basic_button.variations).to eq nil
          basic_button.update_attributes({variants: auto_variants})
          expect(basic_button.variations).to be_instance_of Array
        end

        it "turns lists of hashes into lists of Variations" do
          basic_button.update_attributes({variants: auto_variants})
          expect(basic_button.variations.size).to eq 3
          basic_button.variations.each do |variant|
            expect(variant).to be_instance_of ShareProgress::Variation
          end
        end

        it "updates existing Variations when given a list of hashes" do
          basic_button.update_attributes({variants: auto_variants})
          expect(basic_button.variations.size).to eq 3
          basic_button.update_attributes({variants: auto_variants})
          expect(basic_button.variants.size).to eq 3
        end

      end
    end

    describe 'save', :vcr do

      it 'returns true on a successful save' do
        basic_button.page_url = page_url
        basic_button.button_template = button_template
        expect(basic_button.save).to eq true
      end

      it 'returns false on an unsuccessful save' do
        basic_button.page_url = nil
        expect(basic_button.save).to eq false
      end

      it 'gets rid of existing errors after successful save' do
        basic_button.page_url = nil
        basic_button.save
        expect(basic_button.errors.size).to be > 0
        basic_button.page_url = page_url
        basic_button.button_template = button_template
        basic_button.save
        expect(basic_button.errors).to eq Hash.new
      end

      it 'updates auto-populated fields on successful save' do
        expect(basic_button.page_title).to eq nil
        basic_button.page_url = page_url
        basic_button.button_template = button_template
        basic_button.save
        expect(basic_button.page_title).not_to eq nil
      end
    end

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
          expect{ ShareProgress::Button.find(999999999)}.to raise_error ShareProgress::RecordNotFound
        end

      end

    end

    describe 'create' do

      let(:minimum_args) { {page_url: page_url, button_template: button_template} }

      describe 'making requests' do

        let(:uri) { base_uri + '/buttons/update' }

        it 'requests the update action with base parameters' do
          body_params = HTTParty::HashConversions.to_params(minimum_args)
          params = {query: base_params, body: body_params}
          stub_request(:post, uri).with(params)
          ShareProgress::Button.create(minimum_args)
          expect(WebMock).to have_requested(:post, uri).with(params)
        end

        it 'requests the update action with many parameters' do
          args = {page_title: "xxx", is_active: false}.merge(minimum_args)
          body_params = HTTParty::HashConversions.to_params(args)
          params = {query: base_params, body: body_params}
          stub_request(:post, uri).with(params)
          ShareProgress::Button.create(args)
          expect(WebMock).to have_requested(:post, uri).with(params)
        end

        it 'raises an agument error with only one arguemnt' do
          expect{ ShareProgress::Button.create(page_url) }.to raise_error ArgumentError
        end

        it 'raises an agument error with zero arguemnts' do
          expect{ ShareProgress::Button.create() }.to raise_error ArgumentError
        end
      end

      describe 'receiving data', :vcr do

        describe 'after submitting good params' do

          it 'returns an instance of button' do
            expect(ShareProgress::Button.create(minimum_args)).to be_instance_of ShareProgress::Button
          end

          it 'returns a button with the supplied params and an id' do
            button = ShareProgress::Button.create(minimum_args)
            expect(button.page_url).to eq page_url
            expect(button.button_template).to eq button_template
            expect(button.id).to be > 0
          end

          it 'has empty errors' do
            button = ShareProgress::Button.create(minimum_args)
            expect(button.errors).to eq Hash.new
          end
        end

        describe 'after submitting bad params' do

          let(:bad_params) { {page_url: nil, button_template: nil} }

          it 'returns an instance of button' do
            expect(ShareProgress::Button.create(bad_params)).to be_instance_of ShareProgress::Button
          end

          it 'has appropriate errors' do
            button = ShareProgress::Button.create(bad_params)
            expect( button.errors ).to be_instance_of Hash
            expect( button.errors.keys ).to match_array ['page_url', 'button_template']
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
