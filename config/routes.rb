Rails.application.routes.draw do
  post 'users/create_by_admin'
  resources :tags
  resources :courses
  root 'search#quick_search'
  get '/about', to: 'static_pages#about'
  get '/search', to: 'search#quick_search'

  # Authentication
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'
  post 'search/save_module'

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

  resources :users, except: [:show, :index]
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
