class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
    	t.column :document_id, :integer, :null => false
    	t.column :user_id, :integer, :null => false
    	t.column :rating, :integer, :null => false
    	t.column :description, :string, :null => false  
      t.column :created_at, :datetime, :null => false
    end
  end

  def self.down
    drop_table :reviews
  end
end
