ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.connect 'documents/tag/:name', :controller => 'documents', :action => 'tag'
  map.connect 'documents/tag/:name/:page', :controller => 'documents', :action => 'tag'
  map.connect 'documents/page/:page', :controller => 'documents', :action => 'manage'
  map.connect 'documents/:action/:id', :controller => 'documents'
  map.connect 'document/:action', :controller => 'document'
  map.connect 'podcasts/feed/:name', :controller => 'podcasts', :action => 'feed'
  map.connect 'podcasts/page/:page', :controller => 'podcasts', :action => 'manage'
  map.connect 'podcasts/:action/:id', :controller => 'podcasts'
  map.connect 'groups/page/:page', :controller => 'group', :action => 'manage'
  map.connect 'groups/:action/:id', :controller => 'group'
  map.connect 'subscriptions/tag/:name', :controller => 'subscriptions', :action => 'tag'
  map.connect 'subscriptions/tag/:name/:page', :controller => 'subscriptions', :action => 'tag'
  map.connect 'subscriptions/page/:page', :controller => 'subscriptions', :action => 'manage'
  map.connect 'subscriptions/:action/:id', :controller => 'subscriptions'
  map.connect 'tag/:name', :controller => 'users', :action => 'tag'
  map.connect 'tag/:name/:page', :controller => 'users', :action => 'tag'
  map.connect 'cues/:action/:id', :controller => 'cues'
  map.connect 'casts/:name', :controller => 'casts', :action => 'play'
  map.connect 'casts/:name.:format', :controller => 'casts', :action => 'play'
  map.connect 'user/:action', :controller => 'user'

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
