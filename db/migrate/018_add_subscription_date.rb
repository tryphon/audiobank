class AddSubscriptionDate < ActiveRecord::Migration
  def self.up
  	add_column :subscriptions, :created_at, :datetime
  	Subscription.find(:all).each do |subscription|
  		subscription.created_at = Time.now()
  		subscription.save
  	end
  end

  def self.down
  	remove_column :subscriptions, :created_at
  end
end
