ActionController::Routing::Routes.draw do |map|
  map.resources :subscribers
  map.resources :lists, :member => { :send_test => :get }
  map.resources :subscriptions
  map.root :controller => 'lists', :action => 'index'

end
