class Subscriber < User
	has_many :subscriptions, :dependent => :destroy
	has_many :authors, :through => :subscriptions
	has_many :documents, :through => :subscriptions
end
