Rails.application.routes.draw do
  devise_for :users
  
  # Mount Doorkeeper routes at the root level
  use_doorkeeper
  
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      scope :auth, module: :auth do
        post "/", to: "registrations#create", as: :auth_registration
      end
    end
  end
end
