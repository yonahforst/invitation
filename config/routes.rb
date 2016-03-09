Rails.application.routes.draw do
  resources :invites, controller: 'invitation/invites', only: [:new, :create]
end
