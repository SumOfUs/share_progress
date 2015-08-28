require 'share_progress'
require 'share_progress/variant'
require 'share_progress/twitter_variant'
require 'share_progress/facebook_variant'
require 'share_progress/email_variant'

module ShareProgress

  [EmailVariant, TwitterVariant, FacebookVariant].each do |variant_class|
    describe variant_class do

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

        it 'posts to the button update API URI with the minimum required to update variation'
        it 'does not cause the button to save'
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
