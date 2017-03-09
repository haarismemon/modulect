Rails.application.routes.draw do

  get 'career_search/choose'
  get 'career_search/view'
  get 'errors/not_found'
  get 'errors/internal_server_error'

  namespace :admin do
    resources :courses do
      resources :year_structures, only: :edit
    end
    resources :departments, except: [:show]
    resources :faculties, except: [:show]
    resources :groups, except: [:show]
    resources :tags, except: [:show]
    resources :uni_modules, except: [:show]
    resources :users, except: [:show]
    resources :year_structures, except: [:show]
    resources :career_tags, except: [:show]
    resources :interest_tags, except: [:show]
    get 'upload', to: 'upload#upload'

    post '/uni_modules/bulk_delete', to: 'uni_modules#bulk_delete'

    root to: "dashboard#index"
  end


  # General
  root 'search#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/search', to: 'search#home'
  get '/saved', to: 'saved#view'
  get '/admin', to: 'admin#dashboard'

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

  # Career search
  get '/career-search', to: 'career_search#begin'
  get 'career-search/begin'
  get 'career-search/choose'
  get 'career-search/view_results'

  # Save pathways and modules, and create tags used in ajax
  post 'application/save_module'
  post 'application/save_pathway'
  post 'application/delete_pathway'
  post 'admin/add_new_tag',   to: 'admin/tags#add_new_tag'
  post 'admin/add_new_faculty', to: 'admin/faculties#add_new_faculty'

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

  # Search
  get 'search/pathway_search'
  get 'search/view_results'

  # Pathway search
  get '/pathway-search', to: 'pathway_search#begin'
  get 'pathway-search/begin'
  get 'pathway-search/choose'
  get 'pathway-search/view_results'
  get 'pathway-search/view_results_test'

  # Error pages
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

end
