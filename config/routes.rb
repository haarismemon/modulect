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

  # General
  root 'search#home'
  get '/about', to: 'static_pages#about'
  get '/search', to: 'search#home'
  get '/saved', to: 'saved#view'


  # Authentication
  get     '/login',   to: 'sessions#new'
  get     '/admin/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  # Signup
  get '/signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'

  # Uni Modules
  resources :uni_modules, only: [:show]

  # Search
  get 'search/pathway_search'
  get 'search/view_results'

  # Pathway search
  get '/pathway-search', to: 'pathway_search#begin'
  get 'pathway-search/begin'
  get 'pathway-search/choose'
  get 'pathway-search/view_results'

  # Save pathways and modules used in ajax
  post 'application/save_module'
  post 'application/save_pathway'
  post 'application/delete_pathway'

  # Profile
  get '/*all/update_departments', to: 'users#update_departments', defaults: { format: 'js' }
  get '/*all/update_courses', to: 'users#update_courses', defaults: { format: 'js' }
  post '/users/*all', to: 'users#update'

  # Users
  resources :users, except: [:index]
  post "users/new"
  post 'users/create_by_admin'

  # Password resets
  resources :password_resets, only: [:new, :create, :edit, :update]

  # Account activations
  resources :account_activations, only: [:edit]


end
