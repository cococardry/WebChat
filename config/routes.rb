Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'friendships#index'
  resources :friendships
  resources :conversations, only: [:index, :create] do
    resources :messages
  end
  resources :users
end
