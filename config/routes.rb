ActionController::Routing::Routes.draw do |map|
  map.resources :subscribers
  map.resources :lists
  map.resources :subscriptions
  map.root :controller => 'lists', :action => 'index'
end
