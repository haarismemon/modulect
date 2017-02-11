Rails.application.routes.draw do

  root 'static_pages#home'
  get '/about', to: 'static_pages#about'

  # Authentication
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  # Signup
  get '/signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'

  resources :users, except: [:index]


  # Password resets
  resources :password_resets,     only: [:new, :create, :edit, :update]


  get 'search/quick_search'
  get 'search/smart_search'
  get 'search/view_results'
  get 'search/view_saved'


end
