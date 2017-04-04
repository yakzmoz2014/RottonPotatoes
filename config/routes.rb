Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :movies do
    member do
      post :favorite
      post :not_favorite
    end

    resources :posts
  end

  namespace :account do
    resources :movies
    resources :posts
  end
  root 'welcome#index'
end
