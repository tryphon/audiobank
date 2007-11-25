class AddSubscriberType < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :subscriber_type, :string
    Subscription.update_all "subscriber_type = 'User'"
    change_column :subscriptions, :subscriber_type, :string, :null => false
  end

  def self.down
    remove_column :subscriptions, :subscriber_type
  end
end
