class AddIndexForCastDownloads < ActiveRecord::Migration
  def change
    # Used to detect hotspot Casts, see CastServer.hotspot?
    add_index :downloads, [:cast_id, :format, :created_at]
  end
end
