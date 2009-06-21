require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  before(:each) do
    @user = mock(User)
    controller.stub!(:current_user).and_return(@user)
  end
  
  describe "POST /find" do

    before(:each) do
      @keywords = Document.keywords("dummy")
      @user.stub!(:documents).and_return(mock("documents", :find_by_keywords => []))
      @user.stub!(:find_subscriptions).and_return([])
    end

    def make_request(keywords = @keywords)
      post :find, :keywords => keywords.to_s
    end
    
    it "should assign empty @documents and @subscriptions without keywords" do
      Document.stub!(:keywords).and_return([])
      make_request
      assigns[:documents].should be_empty
      assigns[:subscriptions].should be_empty
    end

    it "should parse keywords with Document.keywords" do
      Document.should_receive(:keywords).with(@keywords.to_s).and_return(@keywords)
      make_request
    end

    it "should find by keywords user's documents" do
      @user.documents.should_receive(:find_by_keywords).with(@keywords).and_return(documents = mock("documents"))
      make_request
      assigns[:documents].should == documents
    end

    it "should find by keywords user's subscriptions" do
      @user.should_receive(:find_subscriptions).with(:keywords => @keywords).and_return(subscriptions = mock("subscriptions"))
      make_request
      assigns[:subscriptions].should == subscriptions
    end

  end

end
