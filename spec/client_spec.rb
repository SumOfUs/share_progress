require 'spec_helper'
require 'webmock/rspec'
require 'share_progress'
require 'httparty'

describe ShareProgress::Client do

  describe "post", :vcr do

    let(:args) { ["/buttons/update", {body: {page_url:"http://act.sumofus.org/sign/What_Fast_Track_Means_infographic/", button_template:"sp_fb_large"}}] }
    let(:response) { [{"id"=>15887, "page_url"=>"http://act.sumofus.org/sign/What_Fast_Track_Means_infographic/", "page_title"=>"What Fast Track Means | SumOfUs.org", "button_template"=>"sp_fb_large", "share_button_html"=>"<div class='sp_15887 sp_fb_large' ></div>", "found_snippet"=>true, "is_active"=>false, "variants"=>{"facebook"=>[], "email"=>[], "twitter"=>[]}, "advanced_options"=>{"automatic_traffic_routing"=>"true", "buttons_optimize_actions"=>nil, "customize_params"=>nil, "id_pass"=>{"id"=>"id", "passed"=>"referrer_id"}}, "errors"=>{}}] }

    it 'returns a formatted response with good args' do
      expect(ShareProgress::Client.post(*args)).to eq response
    end

    it "raises an error when there's a 500 response" do
      key = ShareProgress::Client::default_params[:key]
      ShareProgress::Client::default_params[:key] = 'wrong'
      expect{ ShareProgress::Client.post(*args) }.to raise_error(ShareProgress::ApiError, "Status 500: Bad API Key")
      ShareProgress::Client::default_params[:key] = key
    end
  end

  describe "get", :vcr do

    let(:args) { ["/buttons/read", { query: { id: 15887 } } ] }
    let(:response) { [{"id"=>15887, "page_url"=>"http://act.sumofus.org/sign/What_Fast_Track_Means_infographic/", "page_title"=>"What Fast Track Means | SumOfUs.org", "button_template"=>"sp_fb_large", "share_button_html"=>"<div class='sp_15887 sp_fb_large' ></div>", "found_snippet"=>true, "is_active"=>false, "variants"=>{"facebook"=>[{"id"=>65846, "facebook_title"=>nil, "facebook_description"=>nil, "facebook_thumbnail"=>nil}], "email"=>[{"id"=>65845, "email_subject"=>nil, "email_body"=>nil}], "twitter"=>[{"id"=>65847, "twitter_message"=>nil}]}, "advanced_options"=>{"automatic_traffic_routing"=>"true", "buttons_optimize_actions"=>nil, "customize_params"=>nil, "id_pass"=>{"id"=>"id", "passed"=>"referrer_id"}}, "errors"=>{}}] }

    it 'returns a formatted response with good args' do
      expect(ShareProgress::Client.get(*args)).to eq response
    end

    it "raises an error when there's a 500 response" do
      key = ShareProgress::Client::default_params[:key]
      ShareProgress::Client::default_params[:key] = 'wrong'
      expect{ ShareProgress::Client.get(*args) }.to raise_error(ShareProgress::ApiError, "Status 500: Bad API Key")
      ShareProgress::Client::default_params[:key] = key
    end
  end

end
