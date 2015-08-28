require 'share_progress'
require 'share_progress/variant'
require 'share_progress/twitter_variant'
require 'share_progress/facebook_variant'
require 'share_progress/email_variant'

module ShareProgress
  describe Variant do

 
  end



  [EmailVariant, TwitterVariant, FacebookVariant].each do |variant_class|
    describe variant_class do

      subject { variant_class }

      it { should respond_to :fields }
      it { should respond_to :type }

      describe 'attr_accessors' do
        let(:example) { variant_class.new }

        variant_class.fields.each do |field|
          it "should have a getter method for #{field}" do
            expect{ example.send(field) }.not_to raise_error
          end

          it "should have a setter method for #{field}" do
            setter = "#{field}=".to_sym
            expect{ example.send(setter, nil) }.not_to raise_error
          end
        end
      end
    end
  end
end
