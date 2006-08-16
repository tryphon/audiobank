ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.connect 'documents/tags/:name', :controller => 'documents', :action => 'tags'
  map.connect 'documents/tags/:name/:page', :controller => 'documents', :action => 'tags'
  map.connect 'documents/page/:page', :controller => 'documents', :action => 'manage'
  map.connect 'documents/:action/:id', :controller => 'documents'
  map.connect 'subscriptions/tags/:name', :controller => 'subscriptions', :action => 'tags'
  map.connect 'subscriptions/tags/:name/:page', :controller => 'subscriptions', :action => 'tags'
  map.connect 'subscriptions/page/:page', :controller => 'subscriptions', :action => 'manage'
  map.connect 'subscriptions/:action/:id', :controller => 'subscriptions'
  map.connect 'tags/:name', :controller => 'users', :action => 'tags'
  map.connect 'tags/:name/:page', :controller => 'users', :action => 'tags'
  map.connect 'cues/:action/:id', :controller => 'cues'
  map.connect 'casts/:name', :controller => 'casts', :action => 'play'
  map.connect ':action/:id/:confirm', :controller => 'users', :action => 'confirm'
	map.connect ':action/:id', :controller => 'users'
	
  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => 'users', :action => 'welcome'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
end
