Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "static_pages#index"
  get 'login', to: 'sessions#new', as: 'login'
  get 'sessions', to: 'sessions#destroy', as: 'logout'
  resources :users, only: [:new,:create]
  resources :sessions, only: :create
end
