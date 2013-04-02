require "spec_helper"

describe "Documents API" do

  let(:user) { Factory(:user, :confirmed => true) }

  it "creates a Document" do
    post "/documents.json", :document => { :title => "Dummy", :description => "For test" }, :auth_token => user.authentication_token
    parse_json(response.body, "title").should == "Dummy"
    user.documents.first.title.should == "Dummy"
  end

  let(:document) { Factory(:document, :author => user) }

  it "retrieves a Document" do
    get "/documents/#{document.id}.json", :auth_token => user.authentication_token
    parse_json(response.body, "title").should == document.title
  end

  it "confirms Document upload" do
    FileUtils.cp test_sound_file, document.upload.path
    post "/documents/#{document.id}/upload/confirm.json", :auth_token => user.authentication_token
    document.reload.should be_uploaded
  end

end
