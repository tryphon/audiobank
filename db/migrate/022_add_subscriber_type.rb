class AddSubscriberType < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :subscriber_type, :string, :null => false
    Subscription.update_all "subscriber_type = 'User'"
  end

  def self.down
    remove_column :subscriptions, :subscriber_type
  end
end
