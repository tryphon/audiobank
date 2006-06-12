class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.column :document_id, :integer, :null => false
      t.column :author_id, :integer, :null => false
      t.column :subscriber_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
