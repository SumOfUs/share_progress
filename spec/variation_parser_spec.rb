require 'share_progress'
require 'share_progress/twitter_variation'
require 'share_progress/facebook_variation'
require 'share_progress/email_variation'
require 'share_progress/variation_parser'

module ShareProgress
  describe VariationParser do
    let(:facebook_type) { FacebookVariation }
    let(:facebook_hash) { {facebook_title: 'title'} }
    let(:twitter_type) { TwitterVariation }
    let(:twitter_hash) { {twitter_message: 'message'} }
    let(:email_type) { EmailVariation }
    let(:email_hash) { {email_subject: 'subject'} }

    it 'can correctly identify a facebook hash' do
      expect(VariationParser.parse(facebook_hash)).to eq(facebook_type)
    end

    it 'can correctly identify a twitter hash' do
      expect(VariationParser.parse(twitter_hash)).to eq(twitter_type)
    end

    it 'can correctly identify an email hash' do
      expect(VariationParser.parse(email_hash)).to eq(email_type)
    end

    it 'returns nil on an invalid hash' do
      expect(VariationParser.parse({bad_key: 'bad val'})).to eq(nil)
    end

    it 'returns nil on an empty hash' do
      expect(VariationParser.parse({})).to eq(nil)
    end
  end
end
