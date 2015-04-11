class Listener < ActiveRecord::Base
  validates_presence_of :uid

  @@uuid_generator = UUID.new
  cattr_reader :uuid_generator

  before_validation :create_uid

  def create_uid
    self.uid ||= Listener.uuid_generator.generate
  end
end
