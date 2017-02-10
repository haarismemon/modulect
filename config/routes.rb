Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'users/create_by_admin'
  post 'users/create_by_signup'
  resources :users
  match ':controller(/:action(/:id))', :via => :get
end
