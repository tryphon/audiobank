class Tag < ActiveRecord::Base
	has_and_belongs_to_many :documents
	has_and_belongs_to_many :podcasts
	
	validates_uniqueness_of :name
	validates_presence_of :name
	
	def ==(other)
		self.name == other.name
	end
	
	def self.parse(list)
		tags = Array.new
		
    # remove quoted tags
    list.gsub!(/\"(.*?)\"\s*/ ) { tags << $1; "" }

    # replace all commas with a space
    list.gsub!(/,/, " ")

    # get what is left
    tags.concat list.split(/\s/)

    # strip whitespace
    tags.map! { |t| t.strip }

    # remove any blank tag
    tags = tags.delete_if { |t| t.empty? }
    
    tags.collect! { |t| t.downcase }
    
    tags.collect! { |t| Tag.find_or_create_by_name(t) }
    
    return tags
	end
	
	def to_s
	  name
	end
end
