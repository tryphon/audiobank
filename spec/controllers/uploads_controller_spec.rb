require 'spec_helper'

describe UploadsController do

  let(:document) { Factory :document }
  let(:upload) { document.upload }

  before do
    controller.stub!(:current_user).and_return(document.author)
  end
  
  describe "POST /confirm" do
    
    it "should " do
      FileUtils.cp test_sound_file, upload.path
      post :confirm, :document_id => document
      document.reload.should be_uploaded
    end

  end

end
