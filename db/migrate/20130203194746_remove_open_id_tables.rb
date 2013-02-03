class RemoveOpenIdTables < ActiveRecord::Migration
  def self.up
    drop_table "open_id_associations"
    drop_table "open_id_nonces"
    drop_table "open_id_settings"
    
    remove_column :users, :openid_url
  end

  def self.down
    create_table "open_id_associations", :force => true do |t|
      t.column "server_url", :binary
      t.column "handle", :string
      t.column "secret", :binary
      t.column "issued", :integer
      t.column "lifetime", :integer
      t.column "assoc_type", :string
    end

    create_table "open_id_nonces", :force => true do |t|
      t.column "nonce", :string
      t.column "created", :integer
    end

    create_table "open_id_settings", :force => true do |t|
      t.column "setting", :string
      t.column "value", :binary
    end
    
    add_column(:users, :openid_url, :string)
  end
end
