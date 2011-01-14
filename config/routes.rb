Eopas::Application.routes.draw do

  root :to => "static#home"

  namespace :admin do
    resource :setup_wizard
  end

  # Static
  get 'about', :to => 'static#about', :as => 'about'
  get 'help',  :to => 'static#help',  :as => 'help'

  # Auth
  get 'login',  :to => 'user_sessions#new',     :as => 'login'
  get 'logout', :to => 'user_sessions#destroy', :as => 'logout'

  resource :user_sessions

  # User
  resources :users do
    member do
      get :confirm
    end
  end
  resources :forgotten_passwords

  # Media
  resources :media_items

  # Transcripts
  resources :transcripts do
    get 'eopas', :on => :member, :action => :show, :format => :xml
    get 'new_media_item', :on => :member, :action => :new_attach_media_item
    post 'create_media_item', :on => :member, :action => :create_attach_media_item
  end
end
