class RemoveSubscriptionWithoutSubscriber < ActiveRecord::Migration
  def self.up
    Subscription.find_all.delete_if { |s| ! s.subscriber.nil? }.each do |s|
      puts "destroy subscription #{s.id} (no subscriber)"
      s.destroy
    end
  end

  def self.down

  end
end
