Eopas::Application.routes.draw do

  root :to => "static#home"

  namespace :admin do
    resource :setup_wizard
  end

  # Static
  get 'about', :to => 'static#about', :as => 'about'

  # Auth
  get 'login',  :to => 'user_sessions#new',     :as => 'login'
  get 'logout', :to => 'user_sessions#destroy', :as => 'logout'

  resource :user_session

  # User
  resources :users do
    member do
      get :confirm
    end
  end
  resources :forgotten_passwords

  # Media
  resources :media_items

end
