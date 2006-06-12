class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string, :null => false
      t.column :password, :string, :null => false
      t.column :name, :string, :null => false
      t.column :email, :string, :null => false
    end
  end

  def self.down
    drop_table :users
  end
end
