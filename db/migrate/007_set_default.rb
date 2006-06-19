class SetDefault < ActiveRecord::Migration
  def self.up
  	change_column :documents, :length, :integer, :null => false, :default => 0
  	change_column :documents, :size, :integer, :null => false, :default => 0
  	change_column :documents, :format, :string, :null => false, :default => "application/octet-stream"
  end

  def self.down
  	change_column :documents, :length, :integer, :null => false
  	change_column :documents, :size, :integer, :null => false
  	change_column :documents, :format, :string, :null => false
  end
end
