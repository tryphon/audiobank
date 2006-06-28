class AddTags < ActiveRecord::Migration
  def self.up
		create_table :tags do |t|
			t.column :name, :string
		end
		
		create_table :documents_tags, :id => false do |t|
			t.column :document_id, :integer, :null => false
			t.column :tag_id, :integer, :null => false
		end
  end

  def self.down
  	drop_table :tags
  	drop_table :documents_tags
  end
end
