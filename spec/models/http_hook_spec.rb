require 'spec_helper'

describe HttpHook do

  let(:document) { Factory :audio_document }
  let(:json_body) { JSON.parse FakeWeb.last_request.body }

  before(:each) do
    FakeWeb.allow_net_connect = false    
  end
  
  describe "#document_ready" do

    it "should invoke url with POST request" do
      FakeWeb.register_uri :post, "http://host/path.json", :body => '{"status": "ok"}'
      HttpHook.new("http://host/path.json").document_ready(document)
      
      json_body["document"]["id"].should == document.id
    end

  end

end
