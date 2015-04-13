class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string :uid

      t.belongs_to :listener
      t.belongs_to :document
      t.belongs_to :cast

      # Document and Cast can be deleted
      t.string :cast_name
      t.integer :duration
      t.integer :file_size
      t.string :format

      t.string :ip_address
      t.string :user_agent
      t.string :referer
      t.string :medium

      t.string :city_name
      t.string :country_code

      t.timestamps
    end
    add_index :downloads, :listener_id
    add_index :downloads, :document_id
    add_index :downloads, :cast_id

    add_index :downloads, :uid, uniq: true

    rename_column :casts, :download_count, :downloads_count
  end
end
