Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get "/find", to: 'search#find'
      end
      namespace :items do
        get "/find_all", to: 'search#find_all'
      end
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], to: 'merchant_items#index'
      end
      resources :items, only: [:index, :show, :create, :destroy, :update] do
        resources :merchant, only: [:index], to: 'item_merchants#index'
      end
    end
  end
end
