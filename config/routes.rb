Rails.application.routes.draw do

  resources :departments
  post 'users/create_by_admin'
  resources :tags
  resources :courses
  root 'search#home'
  get '/about', to: 'static_pages#about'
  get '/search', to: 'search#home'
  get 'saved', to: 'saved#view'

  # Authentication
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'
  post 'search/save_module'

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
  get 'search/pathway_search'
  get 'search/view_results'
  get 'search/view_saved'
end
