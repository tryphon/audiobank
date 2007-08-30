class ChangeSubscriptionNotified < ActiveRecord::Migration
  def self.up
    change_column :subscriptions, :notified, :boolean, :null => false, :default => false
  end

  def self.down
    change_column :subscriptions, :notified, :boolean, :null => false
  end
end
