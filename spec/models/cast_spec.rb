require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Cast do

  let(:cast) { Factory(:cast) }

  describe "#uptodate?" do

    it "should be false when cast file doesn't exist" do
      FileUtils.rm_f cast.path
      cast.should_not be_uptodate
    end

    it "should be true when document file doesn't exist" do
      FileUtils.touch cast.path("ogg")
      FileUtils.rm_f cast.document.path
      cast.should be_uptodate("ogg")
    end

    it "should be true when cast file is newer than document file" do
      FileUtils.touch cast.path("ogg")
      FileUtils.touch cast.document.path, :mtime => 0

      cast.should be_uptodate("ogg")
    end

    it "should be false when cast file is older than document file" do
      FileUtils.touch cast.path("ogg"), :mtime => 0
      FileUtils.touch cast.document.path

      cast.should_not be_uptodate("ogg")
    end

  end

  describe "#prepare" do

    let(:document) { cast.document }

    before do
      document.upload_fixture
    end

    it "should create ogg file" do
      cast.prepare
      File.exists?(cast.path("ogg")).should be_true
    end

    it "should create mp3 file" do
      cast.prepare
      File.exists?(cast.path("mp3")).should be_true
    end

    # it "should add Cast to the document" do
    #   cast.prepare
    #   document.casts.should include(cast)
    # end

    # it "should mark Document as ready" do
    #   document.should_receive :ready!
    #   cast.prepare
    # end
  end

  describe ".prepare" do

    let!(:documents) { FactoryGirl.create_list(:document, 5) }
    let!(:to_prepared_document) do
      documents.first.tap do |document|
        document.upload_fixture
      end.reload
    end
    let(:prepared_document) { to_prepared_document.tap(&:prepare).reload }

    it "should create Casts for Document to be prepared" do
      Cast.prepare
      to_prepared_document.casts.should_not be_empty
    end

    it "should update existing Casts" do
      FileUtils.rm prepared_document.casts.first.path("ogg")

      lambda {
        Cast.prepare
      }.should change(prepared_document.casts.first, :uptodate?)
    end

  end

end
