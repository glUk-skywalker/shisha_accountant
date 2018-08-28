Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'events#index'

  match 'signin', to: 'sessions#new', via: :get, as: 'signin'
  match 'auth', to: 'sessions#create', via: [:get, :post], as: 'auth'
  match 'signout', to: 'sessions#destroy', via: :get, as: 'signout'

  resources :users, only: [:index] do
    get 'update_money', to: 'events#new', as: 'update_money'
    resources :events, only: [:create]
  end

  resources :shishas, only: [:new] do
    get 'stop', to: 'shishas#stop', as: 'stop'
    get 'join', to: 'shishas#join', as: 'join'
    get 'leave', to: 'shishas#leave', as: 'leave'
  end

  get 'history', to: 'events#index', as: 'history'

  resources :global_events, only: [:index, :new, :create]
end
