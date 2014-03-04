Src::Application.routes.draw do
  get "auth/auth"
  get 'welcome/index'

  get 'signup' => 'users#new', :as => :signup
  get 'logout' => 'sessions_controllers#destroy', :as => :logout
  get 'login' => 'sessions_controllers#new', :as => :login

  post '/export' => 'statistic#index', as: :export_data
  post '/auth' => 'auth#auth'

  get 'search' => 'welcome#search_form', as: :search_form
  post 'search' => 'welcome#search', as: :search

  get 'user_info' => 'welcome#user_info', as: :user_info

  post 'report' => 'welcome#report', as: :report

  resources :sessions_controllers
  resources :users

  root 'welcome#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
