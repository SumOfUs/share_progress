require 'share_progress'
require 'share_progress/variant'
require 'share_progress/twitter_variant'
require 'share_progress/facebook_variant'
require 'share_progress/email_variant'

require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'
require 'httparty'

module ShareProgress

  [EmailVariant, TwitterVariant, FacebookVariant].each do |variant_class|
    describe variant_class do

      let(:base_params) { { key: ENV['SHARE_PROGRESS_API_KEY'] } }
      let(:base_uri) { ShareProgress::Client::base_uri }
      let(:uri) { base_uri + '/buttons/update' }
      let(:twitter_values) { { "email_subject" => "You won't belive this", "email_body" => nil } }
      let(:facebook_values) { { "twitter_message" => "@bernie2016 <3 <3 <3" } }
      let(:email_values) { { "facebook_title" => "go bernie", "facebook_description" => ";)" } }
      let(:all_values) { {'facebook' => facebook_values, 'email' => email_values, 'twitter' => twitter_values } }
      let(:page_url) { "http://act.sumofus.org/sign/What_Fast_Track_Means_infographic/" }
      let(:button_template) { "sp_fb_large" }
      let(:button) { Button.new(page_url: page_url, button_template: button_template) }
      let(:values) { all_values[variant_class.type].merge(button: button) }
      let(:variant_obj) { variant_class.new(values) }


      subject { variant_class }

      it { should respond_to :fields }
      it { should respond_to :type }

      describe 'attr_accessors' do
        let(:example) { variant_class.new }

        variant_class.fields.each do |field|
          it "has a getter method for #{field}" do
            expect{ example.send(field) }.not_to raise_error
          end

          it "has a setter method for #{field}" do
            setter = "#{field}=".to_sym
            expect{ example.send(setter, nil) }.not_to raise_error
          end
        end
      end

      # we have to test the parent methods through the children, because they have fields

      describe 'serialize' do

        describe 'without values set' do
          it 'includes id and each key in fields, and nothing else'
          it 'does not include button'
          it 'has nil for each value'
        end

        describe 'with values set' do
          it 'includes id and each key in fields, and nothing else'
          it 'does not include button'
          it 'has the correct value for each value'
        end

      end

      describe 'save' do

        describe 'making call' do
          before :each do
            expected_submission = { id: variant_obj.button.id, variants: {variant_obj.type => [variant_obj.serialize]} }
            body_params = HTTParty::HashConversions.to_params(expected_submission)
            @params = {query: base_params, body: body_params}
            stub_request(:post, uri).with(@params)
          end

          it 'posts to the button update API URI with the minimum required to update variation' do
            variant_obj.save
            expect(WebMock).to have_requested(:post, uri).with(@params)
          end

          it "does not call the button's save method" do
            expect(variant_obj.button).not_to receive(:save)
            variant_obj.save
          end
        end

        it "does not cause any of the button's other variations to save"
        it 'adds relevant validation errors to the variation'

      end

      describe 'destroy' do
      end

      describe 'update_attributes' do
      end

    end
  end
end
