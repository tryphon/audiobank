class Author < User
	has_many :subscriptions, :dependent => :destroy
	has_many :subscribers, :through => :subscriptions, :select => "DISTINCT users.*"
	has_many :documents, :dependent => :destroy, :order => "title" do
		def find_by_tag(name, options = Hash.new)
			find_by_sql(["SELECT documents.* FROM documents, tags, documents_tags WHERE documents.id = documents_tags.document_id AND tags.id = documents_tags.tag_id AND documents.author_id = ? AND tags.name = ? OFFSET ? LIMIT ?", @owner.quoted_id, name, options[:offset], options[:limit]])
		end
		
		def find_by_keywords(keywords)
			find(:all, :conditions => ["title ~* ?", keywords])
		end
	end
	has_many :podcasts, :dependent => :destroy
end
