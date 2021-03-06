Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "static_pages#index"
  get 'my_page', to: 'static_pages#my_page'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'signup', to: 'users#new', as: 'signup'
  resources :users, only: [:new,:create]
  resources :sessions, only: :create

  resources :kitchens, only: [:edit] do
    get 'new_copy', to: 'kitchens#new_copy'
    post 'create_copy', to: 'kitchens#create_copy'
    resources :steps, only: [:new,:create,:edit,:update]
    resources :ingredients, only: [:new,:create,:edit,:update]
  end

  resources :recipes, only: [:new,:show,:create,:index,:edit,:update] do
    resources :kitchens, only: [:new,:show,:create,:update]
  end

end
