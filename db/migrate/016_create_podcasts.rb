class CreatePodcasts < ActiveRecord::Migration
  def self.up
		create_table :podcasts do |t|
			t.column :name, :string
			t.column :title, :string
			t.column :description, :string
			t.column :author_id, :integer, :null => false
		end
		
		create_table :podcasts_tags, :id => false do |t|
			t.column :podcast_id, :integer, :null => false
			t.column :tag_id, :integer, :null => false
		end
  end

  def self.down
    drop_table :podcasts
    drop_table :podcasts_tags
  end
end
