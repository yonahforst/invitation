Rails.application.routes.draw do
  resources :invites, only: [:new, :create]
end
