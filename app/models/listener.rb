class Listener < ActiveRecord::Base
  validates_presence_of :uid

  has_many :downloads

  @@uuid_generator = UUID.new
  cattr_reader :uuid_generator

  before_validation :create_uid

  def create_uid
    self.uid ||= Listener.uuid_generator.generate
  end

  def self.from_request(request)
    listener = find_by_cookie(request) || find_by_signature(request)

    request.cookie_jar.signed["listen"] ||= {
      :value => listener.id,
      :expires => 3.months.from_now
    }

    listener
  end

  def self.find_by_cookie(request)
    listener_id = request.cookie_jar.signed["listen"]
    Listener.find_by_id(listener_id) if listener_id
  end

  def self.find_by_signature(request)
    signature = Digest::SHA256.hexdigest "#{request.ip}-#{request.user_agent}"
    Listener.where(:signature => signature).first_or_create
  end

end
