class Subscriber < User
	has_many :authors, :through => :subscriptions
	has_many :documents, :through => :subscriptions
	has_many :subscriptions, :dependent => :destroy do 
		def find_by_tag(name, options = Hash.new)
		  options[:offset] = 0 if options[:offset]
			find_by_sql(["SELECT subscriptions.* FROM subscriptions, documents, tags, documents_tags WHERE subscriptions.document_id = documents.id AND documents.id = documents_tags.document_id AND tags.id = documents_tags.tag_id AND subscriptions.subscriber_id = ? AND tags.name = ? OFFSET ? LIMIT ?", @owner.quoted_id, name, options[:offset], options[:limit]])
		end
		
		def find_by_keywords(keywords)
			find_by_sql(["SELECT subscriptions.* FROM subscriptions, documents WHERE subscriptions.document_id = documents.id AND subscriptions.subscriber_id = ? AND documents.title ~* ?", @owner.quoted_id, keywords])
		end
	end
end
