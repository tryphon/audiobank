require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CastsController do

  describe "play" do

    it "should return a 404 when cast isn't found" do
      lambda {
        get :play, :name => "dummy", :format => "mp3" 
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
    
  end

end
