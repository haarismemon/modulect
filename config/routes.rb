Rails.application.routes.draw do

  # ADMIN
  namespace :admin do
    resources :courses
    resources :departments
    resources :faculties
    resources :groups
    resources :notices
    resources :uni_modules
    patch '/uni_modules' => 'uni_modules#create'
    resources :users, except: [:show] # adding to fix dropdowns
    resources :year_structures
    resources :course_pathways  do
      member do
        get :new_pathway
      end
    end

    # GENERAL
    get 'upload', to: 'upload#upload'
    get 'analytics', to: 'analytics#analytics'
    get 'module_reviews', to: 'module_reviews#message'

    # APP SETTINGS
    put '/app_settings' => 'app_settings#update'
    patch '/app_settings' => 'app_settings#update'
    match 'settings' => 'app_settings#edit', :defaults => {:id => 1}, via: [:get]

    post '/reset_modulect', to: 'base#reset_modulect'
   
    # BULK ACTIONS
    post '/courses/bulk_delete', to: 'courses#bulk_delete'
    post '/courses/clone', to: 'courses#clone'
    post '/departments/bulk_delete', to: 'departments#bulk_delete'
    post '/departments/clone', to: 'departments#clone'
    post '/faculties/bulk_delete', to: 'faculties#bulk_delete'
    post '/faculties/clone', to: 'faculties#clone'
    post '/uni_modules/bulk_delete', to: 'uni_modules#bulk_delete'
    post '/uni_modules/bulk_delete_comments', to: 'uni_modules#bulk_delete_comments'
    post '/users/bulk_activate', to: 'users#bulk_activate'
    post '/users/bulk_deactivate', to: 'users#bulk_deactivate'
    post '/users/bulk_delete', to: 'users#bulk_delete'
    post '/users/bulk_limit', to: 'users#bulk_limit'
    post '/users/bulk_unlimit', to: 'users#bulk_unlimit'
    post '/users/make_student_user', to: 'users#make_student_user'
    post '/users/make_department_admin', to: 'users#make_department_admin'
    post '/users/make_super_admin', to: 'users#make_super_admin'
    post '/notices/bulk_delete', to: 'notices#bulk_delete'
    post '/notices/clone', to: 'notices#clone'

    # RESET MODULECT
    post '/reset_modulect', to: 'base#reset_modulect'

    root to: "dashboard#index"
  end

  # GENERAL
  root 'search#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/search', to: 'search#home'
  get '/saved', to: 'saved#view'
  get '/reviews', to: 'reviews#view'
  get '/admin', to: 'admin#dashboard'
  get 'career_search/choose'
  get 'career_search/view'
  get 'errors/not_found'
  get 'errors/internal_server_error'
  get '/offline', to: 'errors#offline'


  # USERS & AUTHENTICATION
  # Authentication
  get     '/login',   to: 'sessions#new'
  get     '/admin/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  # Signup
  get '/signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'

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


  # SEARCH
  # Search
  get 'search/pathway_search'
  get 'search/view_results'

  # Pathway search
  get '/pathway-search', to: 'pathway_search#begin'
  get 'pathway-search/begin'
  get 'pathway-search/choose'
  get 'pathway-search/view_results'
  post 'pathway-search/increment_pathway_search_log', to: 'pathway_search#increment_pathway_search_log'
  post 'pathway-search/decrement_pathway_search_log', to: 'pathway_search#decrement_pathway_search_log'
  # Pathway search analytics
  get '/*all/update_modules', to: 'admin/analytics#update_modules', defaults: { format: 'js' }
  get '/*all/update_selected_module', to: 'admin/analytics#update_selected_module', defaults: { format: 'js' }
  get '/*all/update_selected_department', to: 'admin/analytics#update_selected_department', defaults: { format: 'js' }


  # Career search
  get '/career-search', to: 'career_search#begin'
  get 'career-search/begin'
  get 'career-search/choose'
  get 'career-search/view_results'

  # UNI MODULES
  # Uni Modules
  resources :uni_modules, only: [:show] do
    resources :comments
  end
  get 'admin/uni_modules/:id/comments', to: 'admin/uni_modules#comments', as: 'admin_comment'


  # AJAX
  # Save pathways and modules, and create tags used in ajax
  post 'application/save_module'
  post 'application/save_pathway'
  post 'application/save_course_pathway'
  post 'application/delete_course_pathway'
  post 'application/update_course_pathway'
  post 'application/delete_pathway'

  get 'application/rating_for_module'
  
  post 'admin/add_new_faculty', to: 'admin/faculties#add_new_faculty'
  post 'comments/sort'
  post 'comments/like'
  post 'comments/edit'
  post 'comments/delete'
  delete 'comments/destroy'
  post 'comments/unflag'


  # ERROR PAGES
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  # OPEN CALAIS
  post 'uni_modules/generate_tags', to: 'admin/uni_modules#generate_tags'

end
