class Download < ActiveRecord::Base
  belongs_to :listener
  belongs_to :document
  belongs_to :cast, counter_cache: true
  belongs_to :user

  attr_accessor :request

  attr_accessible :request, :cast, :format

  before_validation :set_uid, :set_cast_attributes, :set_listener, :set_geoip_attributes, on: :create
  after_save Proc.new { |download| download.cookie.create }

  def set_uid
    self.uid ||= Listener.uuid_generator.generate
  end

  def set_cast_attributes
    if cast
      self.cast_name = cast.name
      self.document = cast.document
      self.duration = document.duration
      self.user_id = document.author_id

      if format
        self.file_size = cast.size(format)
      end
    end
  end

  def set_listener
    self.listener = Listener.from_request(request) if request
  end

  def request=(request)
    @request = request

    self.ip_address = request.ip
    self.referer = request.referer
    self.user_agent = request.user_agent

    self.medium = request.params[:utm_medium]
  end

  def cookie
    Cookie.new self
  end

  def self.cookie_name(cast_name)
    "d/#{cast_name}"
  end

  class Cookie

    attr_accessor :download

    def initialize(download)
      @download = download
    end

    delegate :request, :uid, :cast_name, :duration, to: :download

    def name
      Download.cookie_name cast_name
    end

    def deadline
      Time.now + duration
    end

    def create
      request.cookie_jar[name] = {
        :value => uid,
        :expires => deadline
      }
    end

  end


  @@geoip_city_file = '/usr/share/GeoIP/GeoLiteCity.dat'
  cattr_accessor :geoip_city_file

  def self.load_geoip
    GeoIP.new(geoip_city_file) if geoip_city_file and File.exists?(geoip_city_file)
  end

  @@geoip = nil
  def self.geoip
    @@geoip ||= load_geoip
  end
  def geoip
    self.class.geoip
  end

  def set_geoip_attributes
    return if [city_name, country_code].any?(&:present?)

    if geoip and geoip_city = geoip.city(ip_address)
      self.city_name ||= geoip_city.city_name
      self.country_code ||= geoip_city.country_code3
    end
  end

  def self.find_by_cookie(request, cast_name)
    if download_uid = request.cookie_jar[cookie_name(cast_name)]
      find_by_uid(download_uid)
    end
  end

  def self.from_request(request, cast, format)
    find_by_cookie(request, cast.name) or create(request: request, cast: cast, format: format)
  end
end
