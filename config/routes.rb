Rails.application.routes.draw do
  resources :slots
  root to: "demo#index"
  devise_for :users

  resources :nannies do
    member do
      patch :reserve
      delete :cancel
    end
  end
end
