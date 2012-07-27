class AddDownloadCountOnDocument < ActiveRecord::Migration
  def self.up
    add_column :casts, :download_count, :integer, :default => 0
  end

  def self.down
    remove_column :casts, :download_count
  end
end
