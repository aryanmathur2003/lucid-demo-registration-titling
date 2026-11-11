Rails.application.routes.draw do
  get "healthz", to: "health#show"

  resources :registrations, only: %i[create show] do
    member do
      post :submit
      post :lien_notice
    end
  end
end
