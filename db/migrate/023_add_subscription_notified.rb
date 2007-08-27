class AddSubscriptionNotified < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :notified, :boolean, :null => false
    Subscription.reset_column_information
    Subscription.update_all "notified = 1"
  end

  def self.down
    remove_column :subscriptions, :notified
  end
end
