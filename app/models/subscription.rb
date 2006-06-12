class Subscription < ActiveRecord::Base
	belongs_to :author
	belongs_to :subscriber
	belongs_to :document
end
