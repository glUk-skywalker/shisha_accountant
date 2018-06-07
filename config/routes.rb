Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#show'

  match 'signin', to: 'sessions#new', via: :get, as: 'signin'
  match 'auth', to: 'sessions#create', via: [:get, :post], as: 'auth'
  match 'signout', to: 'sessions#destroy', via: :get, as: 'signout'

  resources :users, only: [:index, :edit, :update]

  resources :shishas, only: [:new, :create] do
    get 'stop', to: 'shishas#stop', as: 'stop'
    get 'join', to: 'shishas#join', as: 'join'
    get 'leave', to: 'shishas#leave', as: 'leave'
  end
  get 'custom_shisha', to: 'shishas#new_custom', as: 'new_custom'
end
