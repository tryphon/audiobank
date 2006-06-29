class Author < User
	has_many :subscriptions, :dependent => :destroy
	has_many :subscribers, :through => :subscriptions, :select => "DISTINCT users.*"
	has_many :documents, :dependent => :destroy do
		def find_by_tag(name)
			find_by_sql(["SELECT documents.* FROM documents, tags, documents_tags WHERE documents.id = documents_tags.document_id AND tags.id = documents_tags.tag_id AND documents.author_id = ? AND tags.name = ?", @owner.quoted_id, name])
		end
	end
end
