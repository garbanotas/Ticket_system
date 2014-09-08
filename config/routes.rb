TaskFromOnApp::Application.routes.draw do
  devise_for :users
  #resources :users
  resources :issues#, only: [:show, :new, :create]

  root 'home#index'
end
