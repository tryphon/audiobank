class AddSubscriptionNotified < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :notified, :boolean
    Subscription.reset_column_information
    Subscription.update_all :notified => true
  end

  def self.down
    remove_column :subscriptions, :notified
  end
end
