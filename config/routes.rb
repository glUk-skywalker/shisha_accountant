Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#show'

  match 'signin', to: 'sessions#new', via: :get, as: 'signin'
  match 'auth', to: 'sessions#create', via: :get, as: 'auth'
  match 'signout', to: 'sessions#destroy', via: :get, as: 'signout'

  resources :users, only: [:index]

  resources :shishas, only: [:new]
  get 'stop_shisha/:id', to: 'shishas#stop', as: 'stop_shisha'
end
