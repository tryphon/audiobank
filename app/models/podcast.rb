class Podcast < ActiveRecord::Base
	has_and_belongs_to_many :tags
	belongs_to :author

  def tag_with(list)
  	Tag.transaction do
  		self.tags = Tag.parse(list)
  	end
  end
  
  def date
  	return Time.now if documents.empty? 
  	documents.last.updated_at
  end
  
  def documents
    documents = Array.new
    for tag in tags
    	tag.documents.delete_if { |d| d.casts.empty?  or d.author != self.author }.each { |d| documents << d }
    end
    return documents.sort_by { |d| d.updated_at }
  end
	
end
