ActionController::Routing::Routes.draw do |map|
  map.signup 'signup', :controller => 'subscribers', :action => 'new'
  map.logout 'logout', :controller => 'sessions', :action => 'destroy'
  map.login 'login', :controller => 'sessions', :action => 'new'
  
  map.resource :sessions
  map.resources :servers
  map.resources :subscribers, :member => { :toggle_administrator => :put }, :collection => { :search => :get }
  map.resources :messages
  map.resources :lists, :member => { :send_test => :get, :subscribe => :get, :unsubscribe => :get }, 
                        :collection => { :available => :get },
                        :has_many => :topics
  map.resources :emails, :collection => { :test => :get }
  map.resources :subscriptions
  map.root :controller => 'lists', :action => 'index'

end
