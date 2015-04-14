class CreateCastServers < ActiveRecord::Migration
  def change
    create_table :cast_servers do |t|
      t.string :public_host
      t.boolean :disabled
      t.float :weight

      t.timestamps
    end
  end
end
