Rails.application.routes.draw do
  root 'top#index'
  get  '/signup', to: 'users#new'
  resources :users
end
