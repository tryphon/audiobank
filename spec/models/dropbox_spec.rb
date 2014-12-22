require 'spec_helper'

describe Dropbox do

  describe ".for_file" do

    it "should be find a Dropbox with the first subdirectory as login" do
      dropbox = Factory :dropbox, directory: "dummy"
      Dropbox.for_file("dummy/test.wav").should == dropbox
    end

    it "should return nil when no associated Dropbox is found" do
      Dropbox.for_file("lost+found").should be_nil
    end

  end

end

describe Dropbox::Import do

  def import(file)
    Dropbox::Import.new user, file
  end

  let(:user) { Factory :user }

  subject { import "dummy/test.wav" }

  describe "#default_title" do

    it "should capitalized basename of the given file" do
      import("dummy/test.wav").default_title.should == "Test"
    end

    it "should replace special characters by whitespace" do
      import("dummy/test-of_special--characters#.wav").default_title.should == "Test of special characters"
    end

    it "should not contain document_id" do
      import("dummy/123 test.wav").default_title.should == "Test"
    end

  end

  describe "#document_id" do

    it "should return the number starting the filename" do
      import("dummy/123-test.wav").document_id.should == 123
      import("dummy/123_test.wav").document_id.should == 123
    end

    it "should be nil if the filename doesn't start by a number" do
      import("dummy/test.wav").document_id.should be_nil
    end

  end

  describe "#basename" do

    it "should be file basename" do
      import("dummy/test.wav").basename.should == "test"
    end

  end

  describe "#document" do

    context "when document_id is present" do

      let(:document) { Factory :document, title: "Existing", author: user }

      it "should find user document by id" do
        import("dummy/#{document.id}-test.wav").document.should == document
      end

      it "should create a new Document if id isn't found" do
        import("dummy/123-test.wav").document.title.should == "Test"
      end

    end

    context "when document_id isn't present" do

      it "should create document" do
        import("dummy/test.wav").document.title.should == "Test"
      end

    end

  end

  describe "#import" do

    let(:file) do
      temp_file = Tempfile.new("audiobank-dropbox")
      FileUtils.cp test_sound_file, temp_file.path
      temp_file.path
    end
    let(:import_file) { import(file) }

    it "should upload file in document" do
      import_file.import
      import_file.document.should be_uploaded
    end

    it "should remove dropbox file" do
      import_file.import
      File.exists?(file).should be_false
    end

  end

end
