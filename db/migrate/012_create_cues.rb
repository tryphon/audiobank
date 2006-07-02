class CreateCues < ActiveRecord::Migration
  def self.up
    create_table :cues do |t|
      t.column :document_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :cues
  end
end
