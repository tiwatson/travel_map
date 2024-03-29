TravelMap::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :maps do
    member do
      get 'kml_update'
      get 'regenerate'
    end
  end
end