class AddConfirmed < ActiveRecord::Migration
  def self.up
  	add_column :users, :confirmed, :boolean, :default => false
  	User.find(:all) do |user|
			user.update_attribute(:confirmed, true) 	
  	end
  end

  def self.down
  	remove_column :users, :confirmed
  end
end
