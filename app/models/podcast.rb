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
    Document.find_by_sql(["SELECT documents.* FROM documents, tags, podcasts_tags, documents_tags WHERE documents.id = documents_tags.document_id AND tags.id = documents_tags.tag_id AND podcasts_tags.tag_id = tags.id AND documents.id IN (SELECT document_id FROM casts) AND podcasts_tags.podcast_id = ? AND documents.author_id = ? ORDER BY documents.updated_at DESC", self.id, self.author_id])
  end
	
end
