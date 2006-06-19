class AddDownloadCount < ActiveRecord::Migration
  def self.up
  	add_column :subscriptions, :download_count, :integer, :default => 0
  	Subscription.find(:all).each do |subscription|
  		subscription.download_count = 0
  		subscription.save
  	end
  end

  def self.down
  	remove_column :subscriptions, :download_count
  end
end
