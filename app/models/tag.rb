class Tag < ActiveRecord::Base
	has_and_belongs_to_many :documents
	has_and_belongs_to_many :podcasts
	
	validates_uniqueness_of :name
	validates_presence_of :name
	
	def ==(other)
		self.name == other.name
	end
	
	def self.parse(list)
	  if list.is_a? Tag
	    return [ list ]
	  end
	  
	  if list.is_a? Array
	    return list.collect { |item| Tag.parse(item) }.flatten
	  end
	  
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
	
	def self.format(tags)
	  tags.join(" ")
	end

	def self.destroy_orphelan_tags
		Tag.find(:all, :include => :documents).each do |tag|
			tag.destroy if tag.documents.empty?
		end
	end

  def match(string)
    self.name.match(string)
  end
	
end
