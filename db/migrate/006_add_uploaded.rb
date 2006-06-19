class AddUploaded < ActiveRecord::Migration
  def self.up
  	add_column :documents, :uploaded, :boolean, :default => false
  	Document.find(:all).each do |document|
  		document.uploaded = !document.size.zero?
  		document.save
  	end
  end

  def self.down
  	remove_column :documents, :uploaded
  end
end
