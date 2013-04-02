AudioBank::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # 

  match '/documents/index', :controller => 'legacy_documents', :action => 'index'
  match '/documents/add', :controller => 'legacy_documents', :action => 'add'
  match '/documents/show/:id', :controller => 'legacy_documents', :action => 'show'
  match '/documents/edit/:id', :controller => 'legacy_documents', :action => 'edit'
  match '/documents/manage', :controller => 'legacy_documents', :action => 'manage'
  match '/documents/upload/:id', :controller => 'legacy_documents', :action => 'upload'
  match '/documents/download/:id', :controller => 'legacy_documents', :action => 'download'
  match '/documents/share/:id', :controller => 'legacy_documents', :action => 'share'
  match '/documents/tag/:name', :controller => 'legacy_documents', :action => 'tag'
  match '/documents/auto_complete_for_tags/:q', :controller => 'legacy_documents', :action => 'auto_complete_for_tags'
  match '/documents/listen/:id', :controller => 'legacy_documents', :action => 'listen'
  match '/documents/auto_complete_for_subscribers/:id', :controller => 'legacy_documents', :action => 'auto_complete_for_subscribers'

  resources :documents do
    resource :upload do
      member do 
        post :confirm
      end
    end
  end

  match '/casts/:name', :controller => 'casts', :action => 'play'
  match '/casts/:name.:format', :controller => 'casts', :action => 'play'

  match '/users/:id/:confirm', :controller => 'users', :action => 'confirm'

  match '/recover_password' => 'users#recover_password'
  match '/signup' => 'users#signup'
  match '/signin' => 'users#signin'

  root :to => 'users#welcome'
  match ':controller(/:action(/:id))(.:format)'
end
