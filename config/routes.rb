Rails.application.routes.draw do
  devise_for :users
  root to: 'feeds#index'

  resources :feeds, only: [:new, :create, :index, :show] do
    resources :articles, only: [:update], controller: 'feed/articles'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
