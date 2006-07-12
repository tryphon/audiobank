class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :document
	
	validates_presence_of :description, :message => "Une description est requise"
	validates_inclusion_of :rating, :in => 0..5, :message => "Une note est requise"
end
