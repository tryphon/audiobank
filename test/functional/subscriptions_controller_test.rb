require File.dirname(__FILE__) + '/../test_helper'
require 'subscriptions_controller'

# Re-raise errors caught by the controller.
class SubscriptionsController; def rescue_action(e) raise e end; end

class SubscriptionsControllerTest < Test::Unit::TestCase
  def setup
    @controller = SubscriptionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
