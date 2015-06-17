Rails.application.routes.draw do
  constraints subdomain: 'api' do
    apipie
    root to: 'apipie/apipies#index'

    get 'login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'

    resources :users, only: [:index, :show, :create, :update  ]
    resources :events, only: [:index, :show, :create, :update ]
    resources :event_judges, only: [:index, :create, :destroy], path: 'judges'
    resources :roles, only: [:index, :show]
  end
end
