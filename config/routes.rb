ActionController::Routing::Routes.draw do |map|
  map.signup 'signup', :controller => 'subscribers', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.login 'login', :controller => 'sessions', :action => 'new'
  
  map.resources :sessions
  map.resources :subscribers
  map.resources :topics
  map.resources :messages
  map.resources :lists, :member => { :send_test => :get }
  map.resources :subscriptions
  map.root :controller => 'lists', :action => 'index'

end
