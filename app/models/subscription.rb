class Subscription < ActiveRecord::Base
	belongs_to :author
	belongs_to :subscriber
	belongs_to :document
	
	validates_uniqueness_of :subscriber_id, :scope => [:document_id]
end
