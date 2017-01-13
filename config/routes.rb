Rails.application.routes.draw do
  devise_for :users,
             controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    post 'users/valid_avatar',
         to: 'users/registrations#valid_avatar', as: 'valid_avatar'
  end

  resources :products do
    post 'valid_thumbnail', to: 'products#valid_thumbnail',
                            as: 'valid_thumbnail', on: :collection
    post 'search', to: 'products#search',
                   as: 'search', on: :collection

    resources :comments, only: [:create, :update, :destroy] do
      put 'modal', to: 'comments#modal', on: :member
    end
  end

  resources :categories, only: :show

  resources :line_items, only: [:create, :destroy] do
    patch 'count_up', to: 'line_items#count_up',
                      as: 'count_up', on: :member
    patch 'count_down', to: 'line_items#count_down',
                        as: 'count_down', on: :member
  end

  resources :carts, only: [:index, :destroy] do
    post 'clean', to: 'carts#clean', on: :collection
  end

  resources :orders, only: [:show, :create] do
    post 'liqpay_response', to: 'orders#liqpay_response',
                            as: 'liqpay_response', on: :collection
    post 'paypal_response', to: 'orders#paypal_response',
                            as: 'paypal_response', on: :collection
    post 'stripe_response', to: 'orders#stripe_response',
                            as: 'stripe_response', on: :member
    put 'modal', to: 'orders#modal', on: :collection
  end

  root 'products#index'

  namespace :admin do
    root 'products#dashboard'

    resources :products, only: [:index, :destroy] do
      put '/', to: 'products#index', on: :collection
    end

    resources :categories, except: [:show, :new, :edit] do
      put 'modal', to: 'categories#modal', on: :member
    end

    resources :comments, only: [:index, :update, :destroy] do
      put 'modal', to: 'comments#modal', on: :member
    end

    resources :users, except: :show do
      put '/', to: 'users#index', on: :collection
    end

    resources :orders, only: [:index, :destroy, :show]
  end

  # mount Sidekiq::Web, at: '/sidekiq'

  get '*any', via: :all, to: 'application#not_found'
  
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
