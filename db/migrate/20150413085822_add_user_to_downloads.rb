class AddUserToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :user_id, :integer
    Download.connection.execute "update downloads, documents set downloads.user_id = documents.author_id where downloads.document_id = documents.id;"
    add_index :downloads, :user_id
  end
end
