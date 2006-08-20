class AddDate < ActiveRecord::Migration
  def self.up
  	add_column :documents, :date, :datetime, :default => false
  	Document.find(:all).each do |document|
  		document.date = DateTime::now()
  		document.save
  	end
  end

  def self.down
  	remove_column :documents, :date
  end
end
