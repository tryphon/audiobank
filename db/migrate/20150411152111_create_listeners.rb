# coding: utf-8
class CreateListeners < ActiveRecord::Migration
  def change
    create_table :listeners do |t|
      t.string :uid
      t.string :signature
      t.timestamps
    end
    add_index :listeners, :uid, uniq: true
    add_index :listeners, :signature
  end
end
