Rails.application.routes.draw do
  constraints subdomain: 'api' do
    apipie
    root to: 'apipie/apipies#index'

    get 'login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'

    resources :users, only: [:index, :show, :create, :update  ] do
      resources :event_judges, only: [:index], as: "judged_events", path: "judged_events", to: "event_judges#index_by_judge"
      resources :event_organizers, only: [:index], as: "organized_events", path: "organized_events", to: "event_organizers#index_by_organizer"
    end

    resources :events, only: [:index, :show, :create, :update ] do
      resources :event_judges,     only: [:create, :destroy, :index], as: "judges", path: "judges"
      resources :event_organizers, only: [:create, :destroy, :index], as: "organizers", path: "organizers"
    end

    resources :roles, only: [:index, :show]
  end
end
