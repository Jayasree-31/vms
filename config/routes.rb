Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, except: [:destroy]

  # API
  namespace :api do
    namespace :v1 do
      resources :users, except: [:destroy] do
        collection do
          post :sign_up
          post :sign_in
        end
      end
      resources :categories, only: :index
      resources :events, except: [:destroy] do
        member do
          post :add_member
        end
      end
    end
  end
end
