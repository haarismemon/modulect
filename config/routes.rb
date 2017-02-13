Rails.application.routes.draw do

  root 'search#quick_search'
  get '/about', to: 'static_pages#about'

  # Authentication
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  # Signup
  get '/signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'

  # Uni Modules
  resources :uni_modules do
    member do
      get :delete
    end
  end

  # Departments
  resources :departments do
    member do
      get :delete
    end
  end

  resources :users, except: [:index]
  post "users/new"

  # Password resets
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Account activations
  resources :account_activations, only: [:edit]

  # Search
  get 'search/quick_search'
  get 'search/smart_search'
  get 'search/view_results'
  get 'search/view_saved'
end
