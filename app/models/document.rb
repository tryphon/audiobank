class Document < ActiveRecord::Base
	belongs_to :author
	has_many :subscribers, :through => :subscriptions
  has_many :subscriptions, :dependent => :destroy
	
	validates_presence_of :title, :message => "Un titre est requis"
	validates_presence_of :description, :message => "Une description est requise"	
end
