class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
      t.column :name, :string,  :null => false
      t.column :description, :string
      t.column :owner_id, :integer, :null => false
    end
    
    create_table :groups_users, :id => false do |t|
      t.column :group_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :groups
    drop_table :groups_users
  end
end
