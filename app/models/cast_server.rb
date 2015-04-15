class CastServer < ActiveRecord::Base
  attr_accessible :disabled, :public_host, :weight

  def self.enabled
    where disabled: [false,nil]
  end

  after_save :clear_public_hosts_sampler

  @@hotspot_hourly_downloads_threshold = 10
  cattr_accessor :hotspot_hourly_downloads_threshold

  def self.hotspot_without_cache?(cast, format)
    cast.downloads_count >= hotspot_hourly_downloads_threshold &&
      cast.downloads.newer_than(1.hour).where(format: format).count >= hotspot_hourly_downloads_threshold
  end

  def self.hotspot_with_cache?(cast, format)
    cache_key = "CastServer/hotspots/#{cast.name}.#{format}"

    if Rails.cache.read(cache_key)
      return true
    else
      hotspot_without_cache?(cast, format).tap do |hotspot|
        Rails.cache.write(cache_key, true, ttl: 1.hour) if hotspot
      end
    end
  end

  def self.hotspot?(cast, format)
    hotspot_with_cache?(cast, format)
  end

  @@secret = nil
  cattr_accessor :secret

  def self.expected_token(request, cast, format)
    if secret
      AccessToken.new(secret: secret, resource: "#{cast.name}.#{format}", target: request.ip).token
    end
  end

  PUBLIC_HOSTS_SAMPLER_CACHE_KEY = "CastServer.public_hosts_sampler".freeze

  def clear_public_hosts_sampler
    self.class.clear_public_hosts_sampler
  end

  def self.clear_public_hosts_sampler
    Rails.cache.delete(PUBLIC_HOSTS_SAMPLER_CACHE_KEY)
  end

  def self.public_hosts_sampler
    Rails.cache.fetch(PUBLIC_HOSTS_SAMPLER_CACHE_KEY) do
      weighted_public_hosts = Hash[enabled.map { |server| [server.public_host, server.weight] }]
      FixedWeightedSampler.new(weighted_public_hosts).prepare
    end
  end

  def self.redirect_url(request, cast, format)
    if public_host = public_hosts_sampler.sample
      if token = expected_token(request, cast, format)
        query = "?token=#{token}"
      end
      "http://#{public_host}/casts/#{cast.name}.#{format}#{query}"
    end
  end

  def self.validate_signature(gocast_signature, cast, format)
    Digest::SHA256.hexdigest("#{secret}-#{cast.name}.#{format}") == gocast_signature
  end

end
