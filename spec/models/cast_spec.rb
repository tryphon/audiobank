require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cast do

  let(:cast) { Factory(:cast) }

  describe "#uptodate?" do
    
    it "should be false when cast file doesn't exist" do
      FileUtils.rm_f cast.path
      cast.should_not be_uptodate
    end

    it "should be true when document file doesn't exist" do
      FileUtils.touch cast.path
      FileUtils.rm_f cast.document.path
      cast.should be_uptodate
    end

    it "should be true when cast file is newer than document file" do
      FileUtils.touch cast.path
      FileUtils.touch cast.document.path, :mtime => 0

      cast.should be_uptodate
    end

    it "should be false when cast file is older than document file" do
      FileUtils.touch cast.path, :mtime => 0
      FileUtils.touch cast.document.path

      cast.should_not be_uptodate
    end

  end

end
