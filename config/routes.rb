Rails.application.routes.draw do
  devise_scope :user do
    get "/sign_in", to: "users/sessions#new"
    get "/sign_up" ,to: "users/registrations#new", as: "new_user_registration"
  end

  devise_for :users, path: "users", controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    unlocks: "users/unlocks",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root "static_pages#home"
  get "static_pages/home"

  delete "/logout", to: "sessions#destroy"

  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")
  get "login_google", to: redirect("/auth/google_oauth2"), as: "login_google"
  get "login_facebook", to: redirect("/auth/facebook"), as: "login_facebook"
  resources :users, only: %i(show index destroy)

  resources :achievements, only: %i(index create)
  resources :teams, except: %i(edit new)
  resources :news, except: %i(edit new)
  resources :comments, only: %i(create destroy)
  resources :players, only: %i(index create show)
  resources :matches
  resources :leagues, except: %i(edit new)
  resources :bets
  get "admincp/show"
  get "matches/new/league/:id", to: "matches#new", as: "league_new_match"
  get "matches/league/:id", to: "matches#load_league_matches", as: "league_all_matches"

  scope "/admincp/" do
    resources :news, except: %i(show index)
    resources :teams, except: %i(show destroy index)
    resources :leagues, except: %i(show destroy index)
    resources :players, only: :new
    resources :achievements
    get "/news", to: "news#index", as: "admin_news"
    get "/players", to: "players#index", as: "admin_players"
    get "/teams", to: "teams#index", as: "admin_teams"
    get "/manage_players/:id", to: "teams#manage_team_players", as: "manage_team_players"
    put "/remove_player/:id", to: "teams#remove_player", as: "remove_player"
    delete "/delete_player/:id", to: "players#destroy", as: "delete_player"
    delete "/delete_achievement/:id", to: "achievements#destroy", as: "delete_achievement"
  end

  mount Ckeditor::Engine => "/ckeditor"
end
