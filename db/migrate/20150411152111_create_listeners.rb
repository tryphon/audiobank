class CreateListeners < ActiveRecord::Migration
  def change
    create_table :listeners do |t|
      t.string :uid
      t.timestamps
    end
    add_index :listeners, :uid, uniq: true
  end
end
