class Subscriber < User
	has_many :subscriptions
	has_many :authors, :through => :subscriptions
	has_many :documents, :through => :subscriptions
end