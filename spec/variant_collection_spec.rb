require 'share_progress'
require 'share_progress/variant_collection'
require 'share_progress/twitter_variant'
require 'share_progress/facebook_variant'
require 'share_progress/email_variant'
require 'share_progress/variant_parser'

module ShareProgress
  describe VariantCollection do

    let(:facebook_hash) { {"id" => 62899, "facebook_title" => "go bernie", "facebook_description" => ";)","facebook_thumbnail" => nil} }
    let(:twitter_hash) { {"id" => 62897, "twitter_message" => "@bernie2016 <3 <3 <3" } }
    let(:email_hash) { {"id" => 62898, "email_subject" => "You won't belive this", "email_body" => "just kidding"} }

    let(:empty_facebook_hash) { {"id" => 62899,"facebook_title" => nil,"facebook_description" => nil,"facebook_thumbnail" => nil} }
    let(:empty_twitter_hash) { {"id" => 62897,"twitter_message" => nil } }
    let(:empty_email_hash) { {"id" => 62898,"email_subject" => nil,"email_body" => nil} }

    let(:basic_variants) { {'twitter' => [twitter_hash], 'email' => [email_hash], 'facebook' => [facebook_hash]} }
    let(:hollow_variants) { {'twitter' => [empty_twitter_hash], 'email' => [empty_email_hash], 'facebook' => [empty_facebook_hash]} }
    let(:hollow_collection) { VariantCollection.new(basic_variants) }

    describe 'new' do

      it 'accepts zero arguments' do
        expect{ VariantCollection.new }.not_to raise_error
      end

      it 'accepts one argument' do
        expect{ VariantCollection.new(basic_variants)}.not_to raise_error
      end
    end

    describe 'update_variants' do

      it 'turns a basic auto generated hash into a list of Variants' do
        expect(hollow_collection.variants.size).to eq 3
        hollow_collection.variants.each do |variant_obj|
          expect(variant_obj).to be_kind_of Variant
        end
      end

      it 'leaves the same Variant instances in use after updating their properties' do
        expect(hollow_collection.variants.size).to eq 3
        v1, v2, v3 = hollow_collection.variants
        hollow_collection.update_variants(basic_variants)
        [v1, v2, v3].each do |v|
          case v.type
          when 'twitter'
            expect(v.twitter_message).to eq basic_variants['twitter'][0]['twitter_message']
          when 'facebook'
            expect(v.facebook_title).to eq basic_variants['facebook'][0]['facebook_title']
          when 'email'
            expect(v.email_body).to eq basic_variants['email'][0]['email_body']
          else
            expect(['twitter', 'facebook', 'email']).to include v.type  # fail
          end
        end
      end

      it 'trims Variants to those included in update call' do
        original_variants = hollow_collection.variants
        hollow_collection.update_variants({'twitter' => [twitter_hash]})
        expect(hollow_collection.variants.size).to eq 1
        expect(original_variants).to include hollow_collection.variants[0]
      end

      it 'can add some while removing others'

    end

  end
end
