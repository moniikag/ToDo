Odot::Application.routes.draw do

  root 'todo_lists#index'

  post 'todo_items/:id/complete' => 'todo_items#complete'

  resources :users, except: [:index, :show] do
    collection do
      get :confirm_email
    end
  end

  resource :user_sessions, only: [:new, :create, :destroy]

  resources :reset_passwords, only: [:new, :create, :update] do
    collection do
      get 'new_password' => 'reset_passwords#edit', as: :new_password
    end
  end

  resources :todo_lists do
    collection do
      post :send_reminder
      get :search
      put :update_field
      post :done
    end

    member do
      post :prioritize
    end

    resources :todo_items do
      member do
        patch :complete
      end
    end

    resources :invitations, only: [:new, :create] do
      collection do
        get :confirm
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
