module DocumentsHelper

  def public_cast_url(document)
    url_for :controller => 'casts', :action => 'play', :name => document.casts.first.name, :only_path => false
  end


end
