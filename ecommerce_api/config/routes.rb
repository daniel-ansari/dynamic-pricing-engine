require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  mount Sidekiq::Web => "/sidekiq"

  namespace :api, defaults: { format: :json } do
    get :status, to: "health#status"

    resources :products, only: %i[index show]

    resources :cart, only: [ :show, :create, :destroy ] do
      delete :remove_item, to: "cart#remove_item", on: :member
    end

    resources :orders, only: [ :create, :destroy ], param: :cart_id
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: redirect("/api-docs")
end
