require File.dirname(__FILE__) + '/../test_helper'
require 'document_controller'

class DocumentController; def rescue_action(e) raise e end; end

class DocumentControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = DocumentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create
    result = invoke :create
    assert_equal nil, result
  end

  def test_get_upload_url
    result = invoke :get_upload_url
    assert_equal nil, result
  end

  def test_confirm_upload
    result = invoke :confirm_upload
    assert_equal nil, result
  end
end
