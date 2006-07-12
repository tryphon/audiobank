class CreateCasts < ActiveRecord::Migration
  def self.up
    create_table :casts do |t|
      t.column :document_id, :integer, :null => false
      t.column :name, :string, :null => false
    end
  end

  def self.down
    drop_table :casts
  end
end
