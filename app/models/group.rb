class Group < ActiveRecord::Base
   has_and_belongs_to_many :users
   belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"

	validates_uniqueness_of :name, :message => "Ce nom de groupe existe déjà"
	validates_presence_of :name, :message => "Un nom de groupe est requis"
	validates_presence_of :description, :message => "Une description du groupe est requise"

  def nonmembers
  	User.find(:all, :conditions => ["confirmed = ?", true]) - users
  end

end
