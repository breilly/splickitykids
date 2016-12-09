Rails.application.routes.draw do

  devise_for :vendors, controllers: { registrations: "vendors/registrations",
    sessions: "vendors/sessions", :omniauth_callbacks => "vendors/omniauth_callbacks" }

  constraints subdomain: 'www' do
    get ':any', to: redirect(subdomain: nil, path: '/%{any}'), any: /.*/
  end

  resources :kids


  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  resources :activities do
    resources :orders, only: [:new, :create]
  end

  resource :search, only: [:show]
  resources :carts do
    collection do
      get 'add_to_cart'
      post 'add'
      get 'place_order'
      post 'complete_order'
    end
  end

 #resources :activities do
 # resource :search, only: [:show]
 #end
  get 'terms', to: "pages#terms"
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'seller' => 'activities#seller'
  get 'sales' => 'orders#sales'
  get 'purchases' => 'orders#purchases'
  get 'unsubscribe' => 'orders#unsubscribe'
  #get 'search', to: 'search#show'

  root 'activities#index'

  namespace :admin do
    root to: "users#index"
    resources :users do
      member do
        get 'change_status'
      end
    end
    resources :vendors do
      member do
        get 'change_status'
      end
    end
  end

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
