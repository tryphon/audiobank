class AddUserToDownloads < ActiveRecord::Migration
  def change
    add_column :downloads, :user_id, :integer

    unless Download.connection.adapter_name == 'SQLite'
      Download.connection.execute "update downloads, documents set downloads.user_id = documents.author_id where downloads.document_id = documents.id;"
    end

    add_index :downloads, :user_id
  end
end
