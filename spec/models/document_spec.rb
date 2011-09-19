require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Document do

  before(:each) do
    @document = Factory(:audio_document)
  end

  it "should create a new instance with factory" do
    @document.should be_valid
  end

  describe "creation" do
    
    it "should have an upload" do
      @document.save!
      @document.upload.should_not be_nil
    end

    it "should have null length" do
      @document.length.should be_zero
    end

  end

  it "should use <id>-<title>.<extname> as filename" do
    @document.title = "title"
    @document.stub!(:id).and_return("id")
    @document.stub!(:extname).and_return("extname")

    @document.filename.should == "id-title.extname"
  end

  describe "extname" do

    def self.it_should_be_for_format(expected, format) 
      it "should be #{expected} for #{format} format" do
        @document.format = format
        @document.extname.should == expected
      end
    end

    it_should_be_for_format "mp3", "audio/mpeg"
    it_should_be_for_format "flac", "audio/x-flac"
    it_should_be_for_format "ogg", "application/ogg"
    it_should_be_for_format "ogg", "audio/x-vorbis+ogg"
    it_should_be_for_format "wav", "audio/x-wav"
    it_should_be_for_format "ogg", "audio/x-vorbis+ogg"
    it_should_be_for_format "ma4", "audio/mp4"

    it "should be nil for unknown format" do
      @document.format = "dummy"
      @document.extname.should be_nil
    end

  end

  it "should use Rails.root/media/id as storage path" do
    @document.path.should == "#{RAILS_ROOT}/media/#{@document.id}"
  end

  it "should have 01:00:00 as duration for a length of 3600 seconds" do
    @document.length = 3600
    @document.duration.strftime("%H:%M:%S").should == "01:00:00"
  end

  describe "validation" do
    
    it "should validate presence of description" do
      @document.description = ""
      @document.should have(1).error_on(:description)
    end

    it "should validate length of description is less than 255 characters" do
      @document.description = "a" * 256
      @document.should have(1).error_on(:description)
    end

    it "should validate presence of title" do
      @document.title = ""
      @document.should have(1).error_on(:title)
    end

  end

  describe "subscribers" do
    
    before(:each) do
      @document = Factory(:audio_document)
      @subscriber = Factory(:user)
      @document.subscriptions.create! :subscriber => @subscriber
    end

    it "should find subscribers through subscriptions" do
      @document.subscribers.should == [ @subscriber ]
    end

  end

  describe "upload" do
    
    before(:each) do
      @file = File.new(File.join(fixture_path, "one-second.ogg"))
    end

    it "should clear existing cues" do
      @document.stub!(:cues).and_return(cues = mock("cues"))
      cues.should_receive(:clear)
      @document.upload_file(@file)
    end

    it "should clear existing casts" do
      @document.stub!(:casts).and_return(casts = mock("casts"))
      casts.should_receive(:clear)
      @document.upload_file(@file)
    end

  end

  describe "after upload" do
    
    before(:each) do
      @file = File.join(fixture_path, "one-second.ogg")
      @document.upload_file(File.new(@file))
    end

    it "should be uploaded" do
      @document.should be_uploaded
    end

    it "should have file time length" do
      @document.length.should == 1
    end

    it "should have file format" do
      @document.format.should == "application/ogg"
    end

    it "should have file size" do
      @document.size.should == File.size(@file)
    end

    def exist
      simple_matcher("exist") do |actual|
        File.exists?(actual)
      end
    end

    it "should create a media file" do
      @document.path.should exist
    end

    def contain_file_data(file)
      simple_matcher("contain file data") do |actual|
        IO.read(actual) == IO.read(file)
      end
    end

    it "should store the file content" do
      @document.path.should contain_file_data(@file)
    end

    it "should not have existing document cues" do
      @document.cues.should be_empty
    end

    it "should not have existing document casts" do
      @document.casts.should be_empty
    end

  end
  
  describe "destroy" do
    
    before(:each) do
      @document = Factory(:audio_document)
    end

    def exist
      simple_matcher("exist") do |actual|
        actual.class.exists?(actual.id)
      end
    end

    it "should destroy associated subscriptions" do
      subscription = @document.subscriptions.create! :subscriber => Factory(:user)
      @document.destroy
      subscription.should_not exist
    end

    it "should destroy associated reviews" do
      # TODO Factory.attributes_for not include :user ??
      review = @document.reviews.create! Factory.attributes_for(:review).update(:user => Factory(:user))
      @document.destroy
      review.should_not exist
    end

    it "should destroy associated casts" do
      cast = @document.casts.create! :name => "dummy"
      @document.destroy
      cast.should_not exist
    end

    it "should destroy associated cues" do
      cue = @document.cues.create!
      @document.destroy
      cue.should_not exist
    end
    
    it "should delete the storage file if exists" do
      File.stub!(:exist?).with(@document.path).and_return(true)
      File.should_receive(:delete).with(@document.path)
      @document.destroy
    end

    it "should delete the storage file if exists" do
      File.stub!(:exist?).and_return(false)
      File.should_not_receive(:delete)
      @document.destroy
    end

    it "should destroy orphelan tags" do
      Tag.should_receive(:destroy_orphelan_tags)
      @document.destroy
    end

  end

  describe "tag_with" do

    before(:each) do
      @tags = [Factory(:tag), Factory(:tag)]
      @list = @tags.collect(&:to_s)
    end

    it "should parse given list" do
      Tag.should_receive(:parse).with(@list).and_return(@tags)
      @document.tag_with(@list)
    end

    it "should replace document tags with parsed ones" do
      Tag.stub!(:parse).and_return(@tags)

      @document.tag_with(@list)
      @document.tags.should == @tags
    end

  end

  it "should destroy orphelan tags when document is saved" do
    Tag.should_receive(:destroy_orphelan_tags)
    @document.save
  end

  describe "match_tags?" do

    before(:each) do
      @document.tags = Array.new(3) { Factory(:tag) }
      @other_tag = Factory(:tag)
    end

    def match_tags(tags)
      simple_matcher("match tags #{Tag.format(Array(tags))}") do |actual|
        actual.match_tags? tags
      end
    end

    it "should be true if given tags are document tags" do
      @document.should match_tags(@document.tags)
    end

    it "should be true if given tags are a part of document tags" do
      @document.should match_tags(@document.tags[0..-1])
    end

    it "should be true if the tag is one of the document tags" do
      @document.should match_tags(@document.tags.first)
    end

    it "should be true if no tag is given" do
      @document.should match_tags([])
    end

    it "should be false if one of the given tags is a document tag" do
      @document.should_not match_tags(@document.tags + [ @other_tag ])
    end
    
  end

  describe "match?" do

    def match(keywords)
      simple_matcher("match keywords #{keywords}") do |actual|
        actual.match? keywords
      end
    end

    it "should match a given string if title does (ignoring case)" do
      @document.title = "matching string"
      @document.should match("MATCH")
    end

    it "should match a given string if description does (ignoring case)" do
      @document.description = "matching string"
      @document.should match("MATCH")
    end

    it "should match a given string if one of the tags does (ignoring case)" do
      @document.tags << Tag.parse("matching_tag")
      @document.should match("MATCH")
    end

    it "should not match a given string if one of the keywords doesn't match" do
      @document.title = "matching string"
      @document.should_not match("UNMATCH")
    end
    
  end

  it "should return existing goups and users except subscribers as nonsubscribers" do
    @nonsubscriber_groups = Array.new(3) { mock(Group) }
    @nonsubscriber_users = Array.new(3) { mock(User) }

    @subscriber_groups = Array.new(3) { mock(Group) }
    @subscriber_users = Array.new(3) { mock(User) }

    Group.stub!(:find).with(:all).and_return(@subscriber_groups + @nonsubscriber_groups)
    User.stub!(:find).with(:all, anything).and_return(@subscriber_users + @nonsubscriber_users)

    @document.stub!(:subscribers).and_return(@subscriber_groups + @subscriber_users)

    @document.nonsubscribers.should == @nonsubscriber_groups + @nonsubscriber_users
  end

  describe "keywords" do

    before(:each) do
      @keywords = Array.new(3) { |n| "keyword#{n}" }
      def @keywords.to_s
        self.join(' ')
      end
    end
    
    it "should return an empty array if string is blank" do
      Document.keywords(nil).should == []
    end

    it "should split given strings" do
      Document.keywords(@keywords.to_s).should == @keywords
    end

    it "should ignore keywords smaller than 3 characters" do
      Document.keywords("#{@keywords} ab").should == @keywords
    end

    it "should downcase words in string" do
      Document.keywords("DUMMY").should == ["dummy"]
    end
    
  end

  describe "#format" do
    
    it "should be 'application/octet-stream' when not uploaded [FIXME]" do
      @document.format.should == "application/octet-stream"
    end

  end

end
