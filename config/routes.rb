Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/create'

  get 'password_resets/edit'

  get 'password_resets/update'

  root 'static_pages#home'

  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  # Authentication
  get     '/login',   to: 'sessions#new'
  post    '/login',   to: 'sessions#create'
  delete  '/logout',  to: 'sessions#destroy'

  # Signup
  get '/signup', to: 'users#new', as: 'signup'
  post 'signup', to: 'users#create'

  resources :users

  get 'search/quick_search'

  get 'search/smart_search'

  get 'search/view_results'

  get 'search/view_saved'
end
