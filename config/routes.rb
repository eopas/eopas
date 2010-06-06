Eopas::Application.routes.draw do |map|

  root  :to => "static#home"

  namespace :admin do
    resource :setup_wizard
  end

  # Static
  map.about 'about', :controller => "static", :action => 'about'

  # Auth
  map.login  'login',  :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.resource :user_sessions

  # User
  map.resources :users, :member => {:confirm => :get}
  map.resources :forgotten_passwords

  # Media
  map.resources :media_items

end
