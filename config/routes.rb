Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  namespace :api, defaults: { format: :json } do
     namespace :v1 do
      scope :auth, module: :auth do
        post "/", to: "registrations#create", as: :auth_registration
      end
    end
   end

end
