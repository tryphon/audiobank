class DocumentController < ApplicationController
  wsdl_service_name 'Document'
  web_service_scaffold :invoke

  before_invocation :authenticate
  skip_before_filter :check_authentication

  def create(user_key, name)
    description = "#{DateTime.now.strftime('Cree le %d/%m/%Y a %H:%m')}"
    @document = 
      AudioDocument.new(:title => name, :description => description)
    @document.author = current_author

    if @document.save
      @document.id
    else
      nil
    end
  end

  def url(user_key, document_id)
    document = author_document(document_id)
    if document.uploaded? or document.upload.nil?
      raise "file already uploaded"
    end
    document.upload.public_url
  end

  def confirm(user_key, document_id)
    document = author_document(document_id)
    
    if document.upload.nil?
      raise "file already uploaded"
    end
    
    unless File.exist?(document.upload.file)
      raise "not uploaded file found"
    end
    
		uploaded = document.upload_file(document.upload.file)			
		unless uploaded 
		  raise "can't import uploaded file"  
		end
		
  	document.upload = nil
    document.save
  end
  
  protected
  
  def current_author
    User.find(@user_id)
  end
  
  def author_document(document_id)
    current_author.documents.find(document_id)
  end
  
  def authenticate(name, args)
    key = args[0]
    
    attributes = Hash.new

    key =~ /(.*)\/(.*)/
    attributes[:username]= $1
    attributes[:password]= $2
    
    user = User.authenticate(attributes)
    if user
      @user_id = user.id
      return nil
    else 
      [ false, "Not authenticated" ]
    end
  end

end
