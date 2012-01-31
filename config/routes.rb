Zlist::Application.routes.draw do

  mount Resque::Server.new, at: "/resque"

  get 'signup', :to => 'subscribers#new'
  get 'logout', :to => 'sessions#destroy'
  get 'login',  :to => 'sessions#new'

  resource :sessions
  resources :servers
  resources :subscribers do
    member do
      put :toggle_administrator
    end
    collection do
      get :search
    end
  end
  resources :messages
  resources :lists do
    member do
      get :send_test
      get :subscribe
      get :unsubscribe
    end
    collection do
      get :available
    end
    resources :topics
  end
  resources :emails do
    collection do
      get :test
    end
  end
  resources :subscriptions

  root :to => 'lists#index'

end
