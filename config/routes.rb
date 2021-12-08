Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
        namespace :merchants do
          get '/find', to: 'search#show'
        end
        namespace :items do
          get '/find_all', to: 'search#index'
        end
        resources :merchants, only: [:index, :show]
        resources :items, only: [:update]
    end
  end
end
