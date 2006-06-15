class AddOrganization < ActiveRecord::Migration
  def self.up
    add_column :users, :organization, :string, :null => true
  end

  def self.down
    remove_column :users, :organization
  end
end
