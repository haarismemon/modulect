Rails.application.routes.draw do

  namespace :admin do
    resources :courses
resources :departments
resources :faculties
resources :groups
resources :tags
resources :uni_modules
resources :users
resources :year_structures
resources :career_tags
resources :interest_tags

    root to: "courses#index"
  end

  root 'search#home'
  get '/about', to: 'static_pages#about'
  get '/search', to: 'search#home'
  get '/saved', to: 'saved#view'

  resources :departments
  resources :tags
  resources :courses
  post 'users/create_by_admin'

  # Authentication
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'
  post 'application/save_module'

  # Signup
  get '/signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'

  # Profile
  get '/*all/update_departments', to: 'users#update_departments', defaults: { format: 'js' }
  get '/*all/update_courses', to: 'users#update_courses', defaults: { format: 'js' }
  post '/users/*all', to: 'users#update'


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

  # Pathway search
  get '/pathway-search', to: 'pathway_search#begin'
  get 'pathway-search/begin'
  get 'pathway-search/choose'
  get 'pathway-search/view_results'


end
