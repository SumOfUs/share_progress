require 'share_progress'
require 'share_progress/variant'
require 'share_progress/twitter_variant'
require 'share_progress/facebook_variant'
require 'share_progress/email_variant'

require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'
require 'httparty'
require 'byebug'

module ShareProgress

  [EmailVariant, TwitterVariant, FacebookVariant].each do |variant_class|
    describe variant_class do

      let(:base_params) { { key: ENV['SHARE_PROGRESS_API_KEY'] } }
      let(:base_uri) { ShareProgress::Client::base_uri }
      let(:uri) { base_uri + '/buttons/update' }

      let(:limited_fields) { { 'twitter' => 'twitter_message', 'facebook' => 'facebook_title', 'email' => 'email_subject' } }
      let(:email_values) { { "email_subject" => nil, "email_body" => "You won't belive this {LINK}", "id" => 1 } }
      let(:twitter_values) { { "twitter_message" => "@bernie2016 <3 <3 <3 {LINK}", "id" => 2 } }
      let(:facebook_values) { { "facebook_title" => "go bernie", "facebook_description" => ";)", "facebook_thumbnail" => nil, "id" => 3 } }
      let(:all_values) { {'facebook' => facebook_values, 'email' => email_values, 'twitter' => twitter_values } }
      let(:nil_facebook) { {facebook_title: nil, facebook_description: nil, facebook_thumbnail: nil, id: nil} }
      let(:nil_twitter) { {twitter_message: nil, id: nil} }
      let(:nil_email) { {email_subject: nil, email_body: nil, id: nil} }

      let(:page_url) { "http://act.sumofus.org/sign/What_Fast_Track_Means_infographic/" }
      let(:button_template) { "sp_fb_large" }
      let(:button) { Button.new(page_url: page_url, button_template: button_template, id: 152) }
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
          it 'includes nil for id and each key in fields, and nothing else' do
            mapper = {
                'facebook' => nil_facebook,
                'twitter' => nil_twitter,
                'email' => nil_email
            }
            obj = variant_class.new
            expect(obj.serialize).to eq(mapper[variant_class.type])
          end
        end

        describe 'with values set' do
          it 'includes correct id and correct value for each key in fields, and nothing else' do
            mapper = {
                'facebook' => facebook_values,
                'twitter' => twitter_values,
                'email' => email_values
            }
            values = Utils.symbolize_keys(mapper[variant_class.type])
            values = values.merge(id: 1)
            obj = variant_class.new values
            expect(obj.serialize).to eq(Utils.symbolize_keys(values))
          end
        end

      end

      describe 'save' do

        describe 'making call' do

          describe 'with button with required parameters' do
            before :each do
              variant_obj.button.id = 12345
              expected_submission = {
                  id: variant_obj.button.id,
                  button_template: variant_obj.button.button_template,
                  page_url: variant_obj.button.page_url,
                  variants: {variant_obj.type => [variant_obj.serialize]}
              }
              body_params = HTTParty::HashConversions.to_params(expected_submission)
              @params = {query: base_params, body: body_params}
              stub_request(:post, uri).with(@params)
            end

            it 'posts to the button update API URI with the required parameters to update variation' do
              variant_obj.save
              expect(WebMock).to have_requested(:post, uri).with(@params)
            end

            it "does not call the button's save method" do
              expect(variant_obj.button).not_to receive(:save)
              variant_obj.save
            end
          end

          describe 'with button without id' do

            before :each do
              variant_obj.button.id = nil
            end

            it 'does not call the URI' do
              variant_obj.save
              expect(WebMock).not_to have_requested(:post, uri)
            end

            it "does not call the button's save method" do
              expect(variant_obj.button).not_to receive(:save)
              variant_obj.save
            end

            it 'adds an appropriate error to the variant' do
              variant_obj.save
              expect(variant_obj.errors).to eq({'button'=> ["must have an id"]})
            end

            it 'returns false' do
              expect(variant_obj.save).to eq false
            end
          end

          describe 'without button' do

            before :each do
              variant_obj.button = nil
            end

            it 'does not call the URI' do
              variant_obj.save
              expect(WebMock).not_to have_requested(:post, uri)
            end

            it 'adds an appropriate error to the variant' do
              variant_obj.save
              expect(variant_obj.errors).to eq({'button'=> ["can't be blank"]})
            end

            it 'returns false' do
              expect(variant_obj.save).to eq false
            end
          end
        end

        describe 'receiving data', :vcr do

          let(:too_long) { "And lo, as the dew fell and the woodland critters retreated into their burrows, a great hush fell upon the forest - TRANQUILITY TURNT UP 100%. " * 10 }

          variant_class.fields.each do |field|
            next if field == :facebook_thumbnail # only field without a character limit
            it "adds validation errors for #{field}" do
              variant_obj.send("#{field}=", too_long)
              expect(variant_obj.save).to eq false
              expect(variant_obj.errors.keys).to eq [field.to_s]
            end
          end

          it "adds validation errors for all fields" do
            fields = variant_class.fields.select{|f| f != :facebook_thumbnail}
            fields.each do |field|
              variant_obj.send("#{field}=", too_long)
            end
            expect(variant_obj.save).to eq false
            expect(variant_obj.errors.keys).to match_array fields.map(&:to_s)
          end

          it "returns true and adds no errors on success" do
            expect(variant_obj.save).to eq true
            expect(variant_obj.errors).to eq Hash.new
          end
        end

      end

      describe 'destroy' do

        context 'succesfully destroying a variant', :vcr do

          describe 'update button' do
            before do
              allow(Button).to receive(:update) {}
            end

            it 'calls Button.update when a variant object is destroyed' do
              variant_obj.destroy
              expect(Button).to have_received(:update)
            end
          end

          it 'returns the variant object if it was succesfully destroyed' do
            result = variant_obj.destroy
            expect(result).to eq(variant_obj)
            expect(result.errors.empty?).to be true
          end

        end

        context 'failing to destroy a variant' do
          before do
            variant_obj.id = nil
          end

          it 'returns false if variant could not be destroyed' do
            result = variant_obj.destroy
            expect(result).to eq(false)
          end

        end
      end

      describe 'update_attributes' do
      end

    end
  end
end
