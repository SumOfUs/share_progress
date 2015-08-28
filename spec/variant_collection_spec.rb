require 'share_progress'
require 'share_progress/variant_collection'
require 'share_progress/twitter_variant'
require 'share_progress/facebook_variant'
require 'share_progress/email_variant'
require 'share_progress/variant_parser'

module ShareProgress
  describe VariantCollection do

    let(:facebook_hash) { {id: 62899, facebook_title: 'go bernie', facebook_description: ';)', facebook_thumbnail: nil} }
    let(:twitter_hash) { {id: 62897, twitter_message: '@bernie2016 <3 <3 <3' } }
    let(:email_hash) { {id: 62898, email_subject: 'You won\'t believe this', email_body: 'just kidding'} }

    let(:empty_facebook_hash) { {id: 62899, facebook_title: nil, facebook_description: nil, facebook_thumbnail: nil} }
    let(:empty_twitter_hash) { {id: 62897, twitter_message: nil } }
    let(:empty_email_hash) { {id: 62898, email_subject: nil, email_body: nil } }

    let(:basic_variants) { {twitter: [twitter_hash], email: [email_hash], facebook: [facebook_hash]} }
    let(:hollow_variants) { {twitter: [empty_twitter_hash], email: [empty_email_hash], facebook: [empty_facebook_hash]} }
    let(:hollow_collection) { VariantCollection.new(basic_variants) }
    let(:empty_variant_collection) { VariantCollection.new({}) }
    let(:twitter_variant) { TwitterVariant.new twitter_message: 'message' }
    let(:email_variant) { EmailVariant.new email_subject: 'Subj', email_body: 'bod'}
    let(:facebook_variant) { FacebookVariant.new facebook_title: 'title', facebook_description: 'desc', facebook_thumbnail: nil}

    describe 'new' do

      it 'accepts zero arguments' do
        expect{ VariantCollection.new }.not_to raise_error
      end

      it 'accepts one argument' do
        expect{ VariantCollection.new(basic_variants)}.not_to raise_error
      end

      it 'calls update_variants'
    end

    describe 'update_variants' do

      it 'turns a basic auto generated hash into a list of Variants' do
        expect(hollow_collection.variants.size).to eq 3
        hollow_collection.variants.each do |variant_obj|
          expect(variant_obj).to be_kind_of Variant
        end
      end

      it 'leaves the same Variant instances in use after updating their properties with a list of Variants'
      it 'leaves the same Variant instances in use after updating their properties with a hash' do
        expect(hollow_collection.variants.size).to eq 3
        v1, v2, v3 = hollow_collection.variants
        hollow_collection.update_variants(basic_variants)
        [v1, v2, v3].each do |v|
          case v.type
          when :twitter
            expect(v.twitter_message).to eq basic_variants[:twitter][0][:twitter_message]
          when :facebook
            expect(v.facebook_title).to eq basic_variants[:facebook][0][:facebook_title]
          when :email
            expect(v.email_body).to eq basic_variants[:email][0][:email_body]
          else
            expect(['twitter', 'facebook', 'email']).to include v.type  # fail
          end
        end
      end

      it 'trims Variants to those included in list of Variants'
      it 'trims Variants to those included in hash' do
        original_variants = hollow_collection.variants
        hollow_collection.update_variants({'twitter' => [twitter_hash]})
        expect(hollow_collection.variants.size).to eq 1
        expect(original_variants).to include hollow_collection.variants[0]
      end

      it 'can add some Variants while removing others'
      it 'can add many Variants all of one type'
      it 'can add from a list of Variant objects'

      it 'can update the button field by passing it referenced in a hash'

    end

    describe 'add_or_update' do

      it 'can add a TwitterVariant from a TwitterVariant object' do
        empty_variant_collection.add_or_update twitter_variant
        expect(empty_variant_collection.variants).to eq([twitter_variant])
      end
      it 'can add a TwitterVariant from an attribute hash' do
        empty_variant_collection.add_or_update twitter_hash
        expect(empty_variant_collection.variants[0]).to be_instance_of(TwitterVariant)
        expect(empty_variant_collection.variants[0].twitter_message).to eq(twitter_hash[:twitter_message])
      end
      it 'can add a EmailVariant from a EmailVariant object' do
        empty_variant_collection.add_or_update email_variant
        expect(empty_variant_collection.variants).to eq([email_variant])
      end
      it 'can add a EmailVariant from an attribute hash' do
        empty_variant_collection.add_or_update email_hash
        expect(empty_variant_collection.variants[0]).to be_instance_of(EmailVariant)
        expect(empty_variant_collection.variants[0].email_subject).to eq(email_hash[:email_subject])
      end
      it 'can add a FacebookVariant from a FacebookVariant object' do
        empty_variant_collection.add_or_update facebook_variant
        expect(empty_variant_collection.variants).to eq([facebook_variant])
      end
      it 'can add a FacebookVariant from an attribute hash' do
        empty_variant_collection.add_or_update facebook_hash
        expect(empty_variant_collection.variants[0]).to be_instance_of(FacebookVariant)
        expect(empty_variant_collection.variants[0].facebook_title).to eq(facebook_hash[:facebook_title])
      end

      # these should guard against duplication
      it 'can update an existing TwitterVariant from a TwitterVariant object' do
        empty_variant_collection.add_or_update twitter_variant
        expect(empty_variant_collection.variants[0].twitter_message).to eq(twitter_variant.twitter_message)
        new_message = 'fake message'
        twitter_variant.twitter_message = new_message
        empty_variant_collection.add_or_update twitter_variant
        expect(empty_variant_collection.variants[0].twitter_message).to eq(new_message)
      end
      it 'can update an existing TwitterVariant from an attribute hash' do
        empty_variant_collection.add_or_update twitter_hash
        expect(empty_variant_collection.variants[0].twitter_message).to eq(twitter_hash[:twitter_message])
        new_hash = twitter_hash
        new_message = 'fake message'
        new_hash[:twitter_message] = new_message
        empty_variant_collection.add_or_update new_hash
        expect(empty_variant_collection.variants[0].twitter_message).to eq(new_message)
      end
      it 'can update an existing EmailVariant from a EmailVariant object' do
        empty_variant_collection.add_or_update email_variant
        expect(empty_variant_collection.variants[0].email_body).to eq(email_variant.email_body)
        new_message = 'fake message'
        email_variant.email_body = new_message
        empty_variant_collection.add_or_update twitter_variant
        expect(empty_variant_collection.variants[0].email_body).to eq(new_message)
      end
      it 'can update an existing EmailVariant from an attribute hash' do
        empty_variant_collection.add_or_update email_hash
        expect(empty_variant_collection.variants[0].email_body).to eq(email_hash[:email_body])
        new_hash = email_hash
        new_message = 'fake message'
        new_hash[:email_body] = new_message
        empty_variant_collection.add_or_update new_hash
        expect(empty_variant_collection.variants[0].email_body).to eq(new_message)
      end
      it 'can update an existing FacebookVariant from a FacebookVariant object' do
        empty_variant_collection.add_or_update facebook_variant
        expect(empty_variant_collection.variants[0].facebook_title).to eq(facebook_variant.facebook_title)
        new_message = 'fake message'
        facebook_variant.facebook_title = new_message
        empty_variant_collection.add_or_update facebook_variant
        expect(empty_variant_collection.variants[0].facebook_title).to eq(new_message)
      end
      it 'can update an existing FacebookVariant from an attribute hash' do
        empty_variant_collection.add_or_update facebook_hash
        expect(empty_variant_collection.variants[0].facebook_title).to eq(facebook_hash[:facebook_title])
        new_hash = facebook_hash
        new_message = 'fake message'
        new_hash[:facebook_title] = new_message
        empty_variant_collection.add_or_update new_hash
        expect(empty_variant_collection.variants[0].facebook_title).to eq(new_message)
      end

    end

    describe 'serialize' do

      it 'is formatted as a hash with each media type as a list of hashes'
      it 'correctly serializes with just one type of media'
      it 'correctly serizlizes with multiple instances of each type of media'
      it 'reflects changes from update_variants'

    end

    describe 'remove' do

      it 'removes a variant referenced by a hash with just id'
      it 'removes two variants with the same id'

      it 'removes a variant referenced by the variant object'
      it 'does not remove anything when passed a different variant with the same id'

      it 'makes the call to the API URI with _destroy true'
    end
  end
end
