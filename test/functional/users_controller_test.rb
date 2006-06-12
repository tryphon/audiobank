require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
	fixtures :users
	
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_signin
    get :signin
    
    assert_response :success
    assert_template 'signin'
    
    assert_not_nil assigns(:user)
  end
  
  def test_post_signin
  	post :signin, :user => {:username => "elmo", :password => "kermit"}
  	
		assert_redirected_to :controller => "documents"
  end
  
  def test_options
  	get :options, nil, :user => users(:bert).id
  	
  	assert_response :success
    assert_template 'options'
    
    assert_not_nil assigns(:user)
    assert assigns(:user).valid?
  end
  
  def test_post_options
  	post :options, { :user => {:name => "bertoldinus"} }, :user => users(:bert).id
  	
  	assert flash.has_key?(:success)
  	
  	assert_response :success
    assert_template 'options'
    
    assert_not_nil assigns(:user)
    assert assigns(:user).valid?
    assert_equal "bertoldinus", assigns(:user).name
  end
end
