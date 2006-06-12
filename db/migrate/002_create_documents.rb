class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
    	t.column :title, :string, :null => false
    	t.column :description, :string, :null => false
    	t.column :author_id, :integer, :null => false
    	t.column :length, :integer, :null => false
    	t.column :size, :integer, :null => false
    	t.column :format, :string, :null => false
    	t.column :type, :string, :null => false
    end
  end

  def self.down
    drop_table :documents
  end
end
