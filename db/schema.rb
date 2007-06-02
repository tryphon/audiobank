# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 20) do

  create_table "casts", :force => true do |t|
    t.column "document_id", :integer,                 :null => false
    t.column "name",        :string,  :default => "", :null => false
  end

  create_table "cues", :force => true do |t|
    t.column "document_id", :integer, :null => false
  end

  create_table "documents", :force => true do |t|
    t.column "title",       :string,   :default => "",                         :null => false
    t.column "description", :string,   :default => "",                         :null => false
    t.column "author_id",   :integer,                                          :null => false
    t.column "length",      :integer,  :default => 0,                          :null => false
    t.column "size",        :integer,  :default => 0,                          :null => false
    t.column "format",      :string,   :default => "application/octet-stream", :null => false
    t.column "type",        :string,   :default => "",                         :null => false
    t.column "uploaded",    :boolean,  :default => false
    t.column "updated_at",  :datetime
  end

  create_table "documents_tags", :id => false, :force => true do |t|
    t.column "document_id", :integer, :null => false
    t.column "tag_id",      :integer, :null => false
  end

  create_table "groups", :force => true do |t|
    t.column "name",        :string,  :default => "", :null => false
    t.column "description", :string
    t.column "owner_id",    :integer,                 :null => false
  end

  create_table "groups_users", :id => false, :force => true do |t|
    t.column "group_id", :integer
    t.column "user_id",  :integer
  end

  create_table "open_id_associations", :force => true do |t|
    t.column "server_url", :binary
    t.column "handle",     :string
    t.column "secret",     :binary
    t.column "issued",     :integer
    t.column "lifetime",   :integer
    t.column "assoc_type", :string
  end

  create_table "open_id_nonces", :force => true do |t|
    t.column "nonce",   :string
    t.column "created", :integer
  end

  create_table "open_id_settings", :force => true do |t|
    t.column "setting", :string
    t.column "value",   :binary
  end

  create_table "podcasts", :force => true do |t|
    t.column "name",        :string
    t.column "title",       :string
    t.column "description", :string
    t.column "author_id",   :integer, :null => false
  end

  create_table "podcasts_tags", :id => false, :force => true do |t|
    t.column "podcast_id", :integer, :null => false
    t.column "tag_id",     :integer, :null => false
  end

  create_table "reviews", :force => true do |t|
    t.column "document_id", :integer,                  :null => false
    t.column "user_id",     :integer,                  :null => false
    t.column "rating",      :integer,                  :null => false
    t.column "description", :string,   :default => "", :null => false
    t.column "created_at",  :datetime,                 :null => false
  end

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "sessions_session_id_index"

  create_table "subscriptions", :force => true do |t|
    t.column "document_id",    :integer,                 :null => false
    t.column "author_id",      :integer,                 :null => false
    t.column "subscriber_id",  :integer,                 :null => false
    t.column "download_count", :integer,  :default => 0
    t.column "created_at",     :datetime
  end

  create_table "tags", :force => true do |t|
    t.column "name", :string
  end

  create_table "uploads", :force => true do |t|
    t.column "document_id", :integer,                 :null => false
    t.column "key",         :string,  :default => "", :null => false
  end

  create_table "users", :force => true do |t|
    t.column "username",     :string,   :default => "",    :null => false
    t.column "password",     :string,   :default => "",    :null => false
    t.column "name",         :string,   :default => "",    :null => false
    t.column "email",        :string,   :default => "",    :null => false
    t.column "organization", :string
    t.column "confirmed",    :boolean,  :default => false
    t.column "created_at",   :datetime
    t.column "openid_url",   :string
  end

end
