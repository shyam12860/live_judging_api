Rails.application.routes.draw do
  apipie

  root to: 'apipie/apipies#index'

  resources :users
end
