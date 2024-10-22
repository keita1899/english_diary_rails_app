Rails.application.routes.draw do
  root 'top#index'
  get '/signup', to: 'users#new'
  delete '/logout', to: 'sessions#destroy'
  get 'profile', to: 'users#edit'
  resources :users, only: %i[new create update]
  resources :sessions, only: %i[new create]
  resources :diaries, only: %i[index]
end
