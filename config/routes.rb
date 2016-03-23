if Invitation.configuration.routes_enabled?
  Rails.application.routes.draw do
    resources :invites, controller: 'invitation/invites', only: [:new, :create]
  end
end
