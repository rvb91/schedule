Rails.application.routes.draw do
  root to: "demo#index"
  devise_for :users
end
