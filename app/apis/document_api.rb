class DocumentApi < ActionWebService::API::Base
  api_method :create, :expects => [:string,:string], :returns => [:int]
  api_method :url, :expects => [:string,:int], :returns => [:string]
  api_method :confirm, :expects => [:string,:int]
end
