class AddSubscriptionNotified < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :notified, :boolean
    Subscription.reset_column_information
    Subscription.update_all "notified = true"
    # change_column :subscriptions, :notified, :boolean, :null => false
  end

  def self.down
    remove_column :subscriptions, :notified
  end
end
