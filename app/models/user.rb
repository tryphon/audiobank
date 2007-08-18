require "digest/sha2"
class User < ActiveRecord::Base
	has_many :reviews, :dependent => :destroy
	has_and_belongs_to_many :groups
	has_many :manageable_groups, :class_name => "Group", :foreign_key => "owner_id"

	validates_uniqueness_of :username, :message => "Ce nom d'utilisateur existe déjà", :if => Proc.new { |u| u.openid_url.nil? }
	validates_presence_of :username, :message => "Un nom d'utilisateur est requis", :if => Proc.new { |u| u.openid_url.nil? }
	validates_format_of :username, :with => /^[-a-z0-9]{3,12}$/, :message => "Un nom d'utilisateur valide est requis"
	validates_presence_of :name, :message => "Votre nom est requis"
  validates_presence_of :password, :message => "Un mot de passe est requis", :if => Proc.new { |u| u.openid_url.nil? }
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :message => "Un email valide pour vous contacter est requis"
	
	def self.digest_password(clear_password)
  	Digest::SHA256.hexdigest(clear_password)
	end
	
	def password=(password)
		write_attribute(:password, User.digest_password(password)) unless password.empty?
	end
	
	def self.authenticate(attributes)
	  username = attributes[:username]
	  
		user = User.find_by_username(username, :conditions => ["confirmed = ?", true])

    if user.blank?
      logger.debug("unknown or unconfirmed user : #{username}")
      return nil
    end
    
    if User.digest_password(attributes[:password]) != user.password
      logger.debug("wrong password for : #{username}")
      return nil
    end
		
    logger.info("user logged : #{username}")
		user
	end
	
	def ==(other)
    id == other.id
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
