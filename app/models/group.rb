# -*- coding: utf-8 -*-
class Group < ActiveRecord::Base

  attr_accessible :name, :description, :user_tokens

   has_and_belongs_to_many :users
   belongs_to :owner, :class_name => "User", :foreign_key => "owner_id"
   
   has_many :subscriptions, :dependent => :destroy, :order => "created_at DESC", :as => "subscriber"

	validates_uniqueness_of :name, :message => "Ce nom de groupe existe déjà"
	validates_presence_of :name, :message => "Un nom de groupe est requis"
	validates_presence_of :description, :message => "Une description du groupe est requise"

  def nonmembers
  	User.find(:all, :conditions => ["confirmed = ?", true]) - users
  end
  
  def match_name?(input)
 	  self.name.downcase.include?(input)
	end

  attr_reader :user_tokens
  def user_tokens=(tokens)
    user_ids = tokens.split(',')
    self.users = User.find user_ids
  end

end
