Rails.application.routes.draw do
  constraints subdomain: 'api' do
    apipie
    root to: 'apipie/apipies#index'

    get 'login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'

    resources :users, only: [:index, :show, :create, :update  ]

    resources :events, only: [:index, :show, :create, :update ] do
      resources :event_judges,     only: [:create, :destroy, :index], as: "judges", path: "judges"
      resources :event_organizers, only: [:create, :destroy, :index], as: "organizers", path: "organizers"
    end

    resources :roles, only: [:index, :show]
  end
end
