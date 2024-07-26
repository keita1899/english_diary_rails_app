Rails.application.routes.draw do
  root 'top#index'
  get  '/signup', to: 'users#new'
  resources :users
  resources :sessions, only: %i[new create]
  resources :diaries, only: %i[index]
end
