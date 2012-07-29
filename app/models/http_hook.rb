class HttpHook

  attr_accessor :url

  def initialize(url)
    @url = url
  end

  def uri
    @uri ||= URI.parse(url)
  end

  def document_ready(document)
    Net::HTTP::Post.new(uri.path, 'Content-Type' =>'application/json').tap do |request|
      # request.basic_auth uri.user, uri.password
      request.body = "{\"document\": #{document.to_json}}"
      Net::HTTP.new(uri.host, uri.port).start { |http| http.request(request) }
    end
    true
  rescue => e
    Rails.logger.error "HttpHook #{url} fails for #{document.id}: #{e}"
    false
  end

end
