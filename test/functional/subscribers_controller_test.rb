require File.dirname(__FILE__) + '/../test_helper'
require 'subscribers_controller'

# Re-raise errors caught by the controller.
class SubscribersController; def rescue_action(e) raise e end; end

class SubscribersControllerTest < Test::Unit::TestCase
  def setup
    @controller = SubscribersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
