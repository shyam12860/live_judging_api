Rails.application.routes.draw do
  constraints subdomain: 'api' do
    apipie
    root to: 'apipie/apipies#index'

    get 'login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'

    resources :messages, only: [:create]

    resources :users, only: [:index, :show, :create, :update  ] do
      resources :event_judges,     only: [:index], as: "judged_events",    path: "judged_events",    to: "event_judges#index_by_judge"
      resources :event_organizers, only: [:index], as: "organized_events", path: "organized_events", to: "event_organizers#index_by_organizer"
      resources :messages, only: [:index]
    end

    resources :event_categories, only: [:update, :destroy, :show], as: "categories", path: "categories"

    resources :event_teams, only: [:update, :destroy, :show], as: "teams", path: "teams" do
      resources :team_categories, only: [:create, :index, :destroy], as: "categories", path: "categories"
    end

    resources :criteria, only: [:show, :update, :destroy]

    resources :team_categories, only: [:show]

    resources :judgments, only: [:show, :update, :create]

    resources :rubrics, only: [:update, :destroy, :show] do
      resources :criteria,          only: [:create, :index]
    end

    resources :event_judges, only: [:destroy], as: "judges", path: "judges" do
      resources :judge_teams, only: [:create, :index, :destroy], as: "teams", path: "teams"
    end

    resources :events, only: [:index, :show, :create, :update ] do
      resources :judgments,        only: [:index]
      resources :event_organizers, only: [:create, :index, :destroy], as: "organizers", path: "organizers"
      resources :event_categories, only: [:create, :index], as: "categories", path: "categories"
      resources :event_teams,      only: [:create, :index], as: "teams",      path: "teams"
      resources :event_judges,     only: [:create, :index], as: "judges",     path: "judges"
      resources :rubrics,          only: [:create, :index]
    end
  end
end
