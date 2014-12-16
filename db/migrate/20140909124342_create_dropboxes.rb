class CreateDropboxes < ActiveRecord::Migration
  def change
    create_table :dropboxes do |t|
      t.string :login
      t.string :password
      t.string :directory

      t.belongs_to :user

      t.timestamps
    end
  end
end
