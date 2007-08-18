class ChangeUsersUsername < ActiveRecord::Migration
  def self.up
    change_column :users, :username, :string, :null => true
    change_column :users, :password, :string, :null => true
  end

  def self.down
    change_column :users, :password, :string, :null => false
    change_column :users, :username, :string, :null => false
  end
end
