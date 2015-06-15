Rails.application.routes.draw do
  constraints subdomain: 'api' do
    # Need to match all routes that are using the options
    match ":asterisk", via: [ :options ]

    apipie
    root to: 'apipie/apipies#index'

    get 'login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'

    resources :users,  only: [:index, :create, :show, :update]
    resources :events, only: [:index, :create, :show, :update]
    resources :roles,  only: [:index, :show]
  end
end
