require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CastsController do

  let(:cast) { Factory :cast }

  describe "play" do

    it "should return a 404 when cast isn't found" do
      lambda {
        get :play, :name => "dummy", :format => "mp3" 
      }.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should increase the download count" do
      get :play, :name => cast.name, :format => "mp3"
      cast.reload
      cast.download_count.should == 1
    end
    
  end

end
