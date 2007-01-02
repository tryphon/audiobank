require "digest/sha2"
class User < ActiveRecord::Base
	has_many :reviews, :dependent => :destroy

	validates_uniqueness_of :username, :message => "Ce nom d'utilisateur existe déjà", :if => Proc.new { |u| u.openid_url.nil? }
	validates_presence_of :username, :message => "Un nom d'utilisateur est requis", :if => Proc.new { |u| u.openid_url.nil? }
	validates_presence_of :name, :message => "Votre nom est requis"
  validates_presence_of :password, :message => "Un mot de passe est requis", :if => Proc.new { |u| u.openid_url.nil? }
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :message => "Un email valide pour vous contacter est requis"
	
	def password=(password)
		write_attribute(:password, Digest::SHA256.hexdigest(password)) unless password.empty?
	end
	
	def self.authenticate(attributes)
		user = User.find_by_username(attributes[:username], :conditions => ["confirmed = ?", true])
		unless user.blank? or Digest::SHA256.hexdigest(attributes[:password]) != user.password
			user
		else
			nil
		end
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
