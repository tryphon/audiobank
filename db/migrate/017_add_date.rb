class AddDate < ActiveRecord::Migration
  def self.up
  	add_column :documents, :updated_at, :datetime
  	Document.find(:all).each do |document|
  		document.updated_at = Time.now()
  		document.save
  	end
  end

  def self.down
  	remove_column :documents, :updated_at
  end
end
