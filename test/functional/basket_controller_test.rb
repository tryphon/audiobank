require File.dirname(__FILE__) + '/../test_helper'
require 'basket_controller'

# Re-raise errors caught by the controller.
class BasketController; def rescue_action(e) raise e end; end

class BasketControllerTest < Test::Unit::TestCase
  def setup
    @controller = BasketController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
