class Subscription < ActiveRecord::Base
	belongs_to :author, :class_name => "User", :foreign_key => "author_id"
	belongs_to :subscriber, :polymorphic => true
	belongs_to :document

	validates_uniqueness_of :subscriber_id, :scope => [:document_id, :subscriber_type]

  before_validation_on_create :define_default_author

	def self.notify
	  unnotified_subscriptions = Subscription.find_all_by_notified(false)

	  unnotified_subscriptions.delete_if do |subscription|
  	  if subscription.users.empty?
  	    subscription.update_attribute(:notified, true)
  	    true
  	  else
  	    false
      end
	  end

	  puts "#{unnotified_subscriptions.size} unnotified subscriptions" unless unnotified_subscriptions.empty?

	  mapped_subscriptions = Hash.new { |hash, user| hash[user] = Array.new }

	  unnotified_subscriptions.inject(mapped_subscriptions) do |map, subscription|
	    subscription.users.each do |user|
	      map[user].push(subscription)
	    end
  	  map
	  end

	  mapped_subscriptions.each do |user, subscriptions|
	    puts "notify #{user.username} for #{subscriptions.size} subscription(s)"
	    Mailer.deliver_document_shared(user, subscriptions)
	    subscriptions.each { |subscription| subscription.update_attribute("notified", true) }
	  end
	end

	def users
	 subscriber.is_a?(Group) ? subscriber.users : [ subscriber ]
	end

  private

  def define_default_author
    self.author = self.document.author
  end

end
