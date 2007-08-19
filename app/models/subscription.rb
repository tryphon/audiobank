class Subscription < ActiveRecord::Base
	belongs_to :author, :class_name => "User", :foreign_key => "author_id"
	belongs_to :subscriber, :polymorphic => true
	belongs_to :document
	
	validates_uniqueness_of :subscriber_id, :scope => [:document_id, :subscriber_type]
end
