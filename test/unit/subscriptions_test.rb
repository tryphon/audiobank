require File.dirname(__FILE__) + '/../test_helper'

class SubscriptionsTest < Test::Unit::TestCase
  fixtures :subscriptions

  def test_truth
    assert_kind_of Subscription, Subscription.find(:first)
  end
end
