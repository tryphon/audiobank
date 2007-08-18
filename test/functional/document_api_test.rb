require File.dirname(__FILE__) + '/../test_helper'
require 'document_controller'

class DocumentController; def rescue_action(e) raise e end; end

class DocumentControllerApiTest < Test::Unit::TestCase
  fixtures :documents, :users

  def setup
    @controller = DocumentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @user = users(:elmo)
    @user_key = "#{@user.username}/#{@user.username}"
    @document = Author.find(@user.id).documents.first
    assert_not_nil @document
  end

  def test_create
    expected_name = "Test"
    id = invoke :create, @user_key, expected_name
    assert_not_nil id
    document = Document.find(id)
  end

  def test_url
    @document.upload = Upload.new
    url = invoke :url, @user_key, @document.id
    assert_equal @document.upload.public_url, url
  end

  def test_confirm
    # result = invoke :confirm
    # assert_equal nil, result
  end
end
