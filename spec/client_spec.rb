require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'
require 'httparty'

describe ShareProgress::Client do

  describe "post", :vcr do

    let(:args) { ["/buttons/update", {body: {page_url:"http//act.sumofus.org/sign/What_Fast_Track_Means_infographic/", button_template:"sp_fb_large"}}] }

    it 'returns a formatted response with good args' do
      expect(ShareProgress::Client.post(*args)).to eq []
    end

    it "raises an error when there's a 500 response" do
      key = ShareProgress::Client::default_params[:key]
      ShareProgress::Client::default_params[:key] = 'wrong'
      expect{ ShareProgress::Client.post(*args) }.to raise_error(ShareProgress::ApiError, "Status 500: Bad API Key")
      ShareProgress::Client::default_params[:key] = key
    end

  end

end
