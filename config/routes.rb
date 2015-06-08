Rails.application.routes.draw do
  resources :users, except: [:new, :edit]
  constraints subdomain: 'api' do
    apipie
    root to: 'apipie/apipies#index'

    resources :users, only: [ :index, :show ]
  end
end
