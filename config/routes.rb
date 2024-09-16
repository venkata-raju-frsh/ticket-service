Rails.application.routes.draw do
  resources :user_role_assignments
  resources :user_roles
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  default_url_options :host => "http://localhost:3000"
  resources :tickets do
    resources :ticket_attachments
    resources :ticket_assignments
  end
  get "/search", to: "ticket_search#search"
  patch "/tickets/:id/status", to: "tickets#update_status"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
