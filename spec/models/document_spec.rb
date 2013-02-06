require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Document do

  subject { Factory :audio_document }

  it "should create a new instance with factory" do
    subject.should be_valid
  end

  describe "creation" do
    
    it "should have an upload" do
      subject.save!
      subject.upload.should_not be_nil
    end

    it "should have null length" do
      subject.length.should be_zero
    end

  end

  it "should use <id>-<title>.<extname> as filename" do
    subject.title = "title"
    subject.stub!(:id).and_return("id")
    subject.stub!(:extname).and_return("extname")

    subject.filename.should == "id-title.extname"
  end

  describe "extname" do

    def self.it_should_be_for_format(expected, format) 
      it "should be #{expected} for #{format} format" do
        subject.format = format
        subject.extname.should == expected
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
      subject.format = "dummy"
      subject.extname.should be_nil
    end

  end

  describe "#path" do

    it "should be Document.root/:id" do
      subject.stub :root => "/root/"
      subject.path.should == "/root/#{subject.id}"
    end
    
  end

  it "should have 01:00:00 as duration for a length of 3600 seconds" do
    subject.length = 3600
    subject.duration.strftime("%H:%M:%S").should == "01:00:00"
  end

  describe "validation" do
    
    it "should validate presence of description" do
      subject.description = ""
      subject.should have(1).error_on(:description)
    end

    it "should validate length of description is less than 255 characters" do
      subject.description = "a" * 256
      subject.should have(1).error_on(:description)
    end

    it "should validate presence of title" do
      subject.title = ""
      subject.should have(1).error_on(:title)
    end

  end

  describe "subscribers" do

    let(:subscriber) { Factory :user }
    
    before(:each) do
      subject.subscriptions.create! :subscriber => subscriber
    end

    it "should find subscribers through subscriptions" do
      subject.subscribers.should == [ subscriber ]
    end

  end

  describe "upload" do
    
    before(:each) do
      @file = File.new(File.join(fixture_path, "one-second.ogg"))
    end

    it "should clear existing cues" do
      subject.stub!(:cues).and_return(cues = mock("cues"))
      cues.should_receive(:clear)
      subject.upload_file(@file)
    end

    it "should clear existing casts" do
      subject.stub!(:casts).and_return(casts = mock("casts"))
      casts.should_receive(:clear)
      subject.upload_file(@file)
    end

  end

  describe "after upload" do
    
    before(:each) do
      @file = File.join(fixture_path, "one-second.ogg")
      subject.upload_file(File.new(@file))
    end

    it "should be uploaded" do
      subject.should be_uploaded
    end

    it "should have file time length" do
      subject.length.should == 1
    end

    it "should have file format" do
      subject.format.should == "application/ogg"
    end

    it "should have file size" do
      subject.size.should == File.size(@file)
    end

    extend RSpec::Matchers::DSL
    
    matcher :exist do
      match do |actual|
        File.exists?(actual)
      end
    end

    it "should create a media file" do
      subject.path.should exist
    end

    RSpec::Matchers.define :contain_file_data do |expected|
      match do |actual|
        IO.read(actual) == IO.read(expected)
      end
    end

    it "should store the file content" do
      subject.path.should contain_file_data(@file)
    end

    it "should not have existing document cues" do
      subject.cues.should be_empty
    end

    it "should not have existing document casts" do
      subject.casts.should be_empty
    end

  end
  
  describe "destroy" do
    
    before(:each) do
      subject = Factory(:audio_document)
    end

    extend RSpec::Matchers::DSL

    matcher :exist do
      match do |actual|
        actual.class.exists?(actual.id)
      end
    end

    it "should destroy associated subscriptions" do
      subscription = subject.subscriptions.create! :subscriber => Factory(:user)
      subject.destroy
      subscription.should_not exist
    end

    it "should destroy associated reviews" do
      # TODO Factory.attributes_for not include :user ??
      review = subject.reviews.create! Factory.attributes_for(:review).update(:user => Factory(:user))
      subject.destroy
      review.should_not exist
    end

    it "should destroy associated casts" do
      cast = subject.casts.create! :name => "dummy"
      subject.destroy
      cast.should_not exist
    end

    it "should destroy associated cues" do
      cue = subject.cues.create!
      subject.destroy
      cue.should_not exist
    end
    
    it "should delete the storage file if exists" do
      File.stub!(:exist?).with(subject.path).and_return(true)
      File.should_receive(:delete).with(subject.path)
      subject.destroy
    end

    it "should delete the storage file if exists" do
      File.stub!(:exist?).and_return(false)
      File.should_not_receive(:delete)
      subject.destroy
    end

    it "should destroy orphelan tags" do
      subject.tap do |document|
        Tag.should_receive(:destroy_orphelan_tags)
        document.destroy
      end
    end

  end

  describe "tags_token" do

    let(:tags) { [ Factory(:tag), Factory(:tag) ] }
    let(:list) { tags.collect &:to_s }

    it "should parse given list" do
      Tag.should_receive(:parse).with(list).and_return(tags)
      subject.tag_tokens = list
    end

    it "should replace document tags with parsed ones" do
      Tag.stub!(:parse).and_return(tags)
      subject.tag_tokens = list

      subject.tags.should == tags
    end

  end

  describe "subscriber_tokens=" do

    let(:subscriber) { Factory :user }

    it "should create a new Subscription with new Subscriber" do
      subject.subscriber_tokens = "user:#{subscriber.id}"
      subject.subscribers.should == [ subscriber ]
    end

    it "should support User" do
      user = Factory(:user)
      subject.subscriber_tokens = "user:#{user.id}"
      subject.subscribers.should == [ user ]
    end

    it "should support Group" do
      group = Factory(:group)
      subject.subscriber_tokens = "group:#{group.id}"
      subject.subscribers.should == [ group ]
    end

    it "should keep existing Subscriptions" do
      previous_subscriber = Factory(:user)
      subject.subscriptions.create :subscriber => previous_subscriber

      subject.subscriber_tokens = "user:#{subscriber.id},user:#{previous_subscriber.id}"
      subject.subscribers.should =~ [previous_subscriber, subscriber]
    end
    
  end

  it "should destroy orphelan tags when document is saved" do
    subject.tap do |document|
      Tag.should_receive(:destroy_orphelan_tags)
      document.save!
    end
  end

  describe "match_tags?" do

    before(:each) do
      subject.tags = Array.new(3) { Factory(:tag) }
      @other_tag = Factory(:tag)
    end

    RSpec::Matchers.define :match_tags do |tags|
      match do |actual|
        actual.match_tags? tags
      end
    end

    it "should be true if given tags are document tags" do
      subject.should match_tags(subject.tags)
    end

    it "should be true if given tags are a part of document tags" do
      subject.should match_tags(subject.tags[0..-1])
    end

    it "should be true if the tag is one of the document tags" do
      subject.should match_tags(subject.tags.first)
    end

    it "should be true if no tag is given" do
      subject.should match_tags([])
    end

    it "should be false if one of the given tags is a document tag" do
      subject.should_not match_tags(subject.tags + [ @other_tag ])
    end
    
  end

  describe "match?" do

    RSpec::Matchers.define :match do |keywords|
      match do |actual|
        actual.match? keywords
      end
    end

    it "should match a given string if title does (ignoring case)" do
      subject.title = "matching string"
      subject.should match("MATCH")
    end

    it "should match a given string if description does (ignoring case)" do
      subject.description = "matching string"
      subject.should match("MATCH")
    end

    it "should match a given string if one of the tags does (ignoring case)" do
      subject.tags << Tag.parse("matching_tag")
      subject.should match("MATCH")
    end

    it "should not match a given string if one of the keywords doesn't match" do
      subject.title = "matching string"
      subject.should_not match("UNMATCH")
    end
    
  end

  it "should return existing goups and users except subscribers as nonsubscribers" do
    @nonsubscriber_groups = Array.new(3) { mock(Group) }
    @nonsubscriber_users = Array.new(3) { mock(User) }

    @subscriber_groups = Array.new(3) { mock(Group) }
    @subscriber_users = Array.new(3) { mock(User) }

    Group.stub!(:find).with(:all).and_return(@subscriber_groups + @nonsubscriber_groups)
    User.stub!(:find).with(:all, anything).and_return(@subscriber_users + @nonsubscriber_users)

    subject.stub!(:subscribers).and_return(@subscriber_groups + @subscriber_users)

    subject.nonsubscribers.should == @nonsubscriber_groups + @nonsubscriber_users
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
      subject.format.should == "application/octet-stream"
    end

  end

  describe "#format=" do

    it "should ignore additionnal information (; and after)" do
      subject.format = "application/ogg; charset=binary"
      subject.format.should == "application/ogg"
    end

  end

  describe "#ready!" do

    before(:each) do
      Factory :cast, :document => subject
    end

    let(:hook) { mock }
    
    it "should invoke hooks with document_ready" do
      subject.stub :hooks => [hook]
      hook.should_receive(:document_ready).with(subject)
      subject.ready!
    end

  end

end
