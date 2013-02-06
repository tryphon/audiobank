# -*- coding: utf-8 -*-
require "digest/sha2"
class User < ActiveRecord::Base

  attr_accessible :name, :password, :email, :username, :organization

  def full_name
    [].tap do |parts|
      parts << name
      parts << "(#{organization})" if organization.present?
    end.join(' ')
  end

	has_many :reviews, :dependent => :destroy

	has_many :documents, :dependent => :destroy, :order => "updated_at DESC", :foreign_key => "author_id" do
		def find_by_tag(name, options = Hash.new)
	    tag = Tag.find_by_name(name)
		  documents = find(:all).delete_if { |d| !d.tags.include?(tag) }

  	  if options[:offset] and options[:limit]
  	    documents.slice!(options[:offset], options[:limit])
  	  end

  	  documents
		end

		def find_by_keywords(keywords)
			find(:all).delete_if { |d| !d.match?(keywords) }
		end

    def download_count
      # FIXME very very old school
      Cast.sum(:download_count, :conditions => { :document_id => proxy_association.owner.document_ids })
    end
	end


	has_many :subscriptions, :dependent => :destroy, :order => "created_at DESC", :as => "subscriber"

	has_many :podcasts, :dependent => :destroy, :foreign_key => "author_id"

	has_and_belongs_to_many :groups
	has_many :manageable_groups, :class_name => "Group", :foreign_key => "owner_id"

	validates_uniqueness_of :username, :message => "Ce nom d'utilisateur existe déjà"
	validates_presence_of :username, :message => "Un nom d'utilisateur est requis"
	validates_format_of :username, :with => /^[-a-z0-9]*$/, :message => "Le nom d'utilisateur ne peut contenir que des minuscules, des chiffres et '-' (a..z0..9-)"

	validates_length_of :username, :in => 3..20,
	  :too_long => "Le nom d'utilisateur est limité à %{count} caractères",
	  :too_short => "Le nom d'utilisateur doit faire au moins %{count} caractères"

	validates_presence_of :name, :message => "Votre nom est requis"
  validates_presence_of :password, :message => "Un mot de passe est requis"
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :message => "Un email valide pour vous contacter est requis"

	def tags
	  subscriptions_tags = find_subscriptions.collect{ |s| s.document.tags }.flatten
	  documents_tags = documents.collect{ |d| d.tags }.flatten
	  (subscriptions_tags + documents_tags).uniq
	end

	def find_subscriptions(options = Hash.new)
	  group_subscriptions = groups.collect{ |group| group.subscriptions }.flatten
	  all_subscriptions = self.subscriptions + group_subscriptions

	  sorted_attribute = "created_at"
	  all_subscriptions = all_subscriptions.sort_by { |s| s[sorted_attribute] }.reverse

	  if options[:tag]
  	  options[:tags] = Tag.parse(options[:tag])
	  end

	  if options[:tags]
	    tags = Tag.parse(options[:tags])
  	  all_subscriptions = all_subscriptions.delete_if { |s| ! s.document.match_tags?(tags) }
  	end

  	if options[:keywords]
  	  all_subscriptions = all_subscriptions.delete_if do |s|
  	    !s.document.match?(options[:keywords])
  	  end
  	end

	  if options[:offset] and options[:limit]
	    return all_subscriptions.slice(options[:offset], options[:limit])
	  end

	  all_subscriptions
	end

	def find_documents(options = Hash.new)
	  documents = self.documents.find(:all)

	  if options[:tag]
  	  options[:tags] = Tag.parse(options[:tag])
	  end

	  if options[:tags]
	    tags = Tag.parse(options[:tags])
		  documents = documents.delete_if do |document|
		    !document.match_tags?(tags)
		  end
		end

  	if options[:keywords]
  	  documents = documents.delete_if do |document|
  	    !document.match?(options[:keywords])
  	  end
  	end

	  if options[:order_by]
	    documents = documents.sort_by(&options[:order_by])
	  end

	  if options[:offset] and options[:limit]
	    documents.slice!(options[:offset], options[:limit])
	  end

	  documents
	end


	def find_subscription(id)
	  subscription = self.subscriptions.find_by_id(id)
    unless subscription
	    for group in groups
	      subscription = group.subscriptions.find_by_id(id)
	      break unless subscription.nil?
	    end
    end
	  subscription
	end

	def self.digest_password(clear_password)
  	Digest::SHA256.hexdigest(clear_password)
	end

	def password=(password)
		write_attribute(:password, User.digest_password(password)) unless password.empty?
	end

	def self.authenticate(username, clear_password)
		user = User.find_by_username(username, :conditions => ["confirmed = ?", true])

    if user.blank?
      logger.debug("unknown or unconfirmed user : #{username}")
      return nil
    end

    if User.digest_password(clear_password) != user.password
      logger.debug("wrong password for : #{username}")
      return nil
    end

    logger.info("user logged : #{username}")
		user
	end

	def change_password
	  generated_password = new_password
	  update_attribute(:password, generated_password)
	  UserMailer.new_password(self, generated_password).deliver
	end

	def new_password
	  random_sha = Digest::SHA256.hexdigest rand.to_s
	  random_sha[-10..-1]
	end

	def match_name?(input)
	  (self.name.downcase.include?(input) or (not self.username.nil? and self.username.downcase.include?(input)))
	end

	def hashcode
    Digest::SHA256.hexdigest(id.to_s + email)
  end

  def confirmed?
  	confirmed
  end

  def after_save
  	User.destroy_all(["confirmed = ? AND created_at <= ?", false, Time.new - 2592000])
  end

end
