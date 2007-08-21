class Podcast < ActiveRecord::Base
	has_and_belongs_to_many :tags
	belongs_to :author, :class_name => "User", :foreign_key => "author_id"

  def tag_with(list)
  	Tag.transaction do
  		self.tags = Tag.parse(list)
  	end
  end
  
  def date
  	return Time.now if documents.empty? 
  	documents.first.updated_at
  end
  
  def documents
    self.author.find_documents(:tags => self.tags)
  end
	
end
