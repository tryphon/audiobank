class AccessToken
  attr_accessor :secret, :target, :time

  def initialize(attributes = {})
    attributes.each { |k,v| send "#{k}=", v }
  end

  def time
    @time ||= Time.now
  end

  @@time_period = 5.minutes
  cattr_accessor :time_period

  def seconds
    time.to_i / 300
  end

  def data
    "#{secret}-#{target}-#{seconds}"
  end

  def token
    Digest::SHA256.hexdigest data
  end
  alias_method :to_s, :token

  def previous_period
    change_time -time_period
  end

  def next_period
    change_time time_period
  end

  def change_time(duration)
    dup.tap do |other|
      other.time = time + duration
    end
  end

  def validate(token)
    [self, previous_period, next_period].any? do |instance|
      instance.token == token
    end
  end
end
