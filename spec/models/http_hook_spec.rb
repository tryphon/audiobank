require 'spec_helper'

describe HttpHook do

  let(:document) { Factory :audio_document }

  let(:url) { "http://host/path.json" }
  let(:json_body) { JSON.parse FakeWeb.last_request.body }

  before(:each) do
    FakeWeb.allow_net_connect = false    
  end
  
  describe "#document_ready" do

    it "should invoke url with POST request" do
      FakeWeb.register_uri :post, url, :body => '{"status": "ok"}'
      HttpHook.new(url).document_ready(document)
      
      json_body["document"]["id"].should == document.id
    end

    it "should ignore http errors" do
      FakeWeb.register_uri(:post, url, :exception => Net::HTTPError)
      
      lambda {
        HttpHook.new(url).document_ready(document)
      }.should_not raise_error
    end

  end

end
