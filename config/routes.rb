Testmite::Application.routes.draw do
  
  root 'suites#index'
  get "suites" => 'suites#index'
  get "suites/:id" => 'suites#show'
  
  get "keys" => 'keys#show'
  
  get "runs/show"
  get "worlds/show"
  get "worlds/index"
  get "worlds/search" => 'worlds#search'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  get 'worlds' => 'worlds#index'
  get 'worlds/:id' => 'worlds#show'
  get 'worlds/:primary/:reference' => 'worlds#compare'
  
  get 'aggregate/:world_id' => 'worlds#aggregate_element'
  get 'comparison/:primary/:reference' => 'worlds#comparison_element'

  get 'runs/:id'   => 'runs#show'
  
  get 'oldtests/:id'  => 'tests#show'
  get 'tests/:id'  => 'tests#history'
  

  get '/status' => 'api/v1/status#show'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post 'submit' => 'results#ingest_ir'
    end
  end

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
