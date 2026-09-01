Rails.application.routes.draw do

  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :events, only: [:index, :show, :create]
        resources :reservations, only: [:show, :create]

        post "/login", to: "auth#login"
      end
    end
  end
end
