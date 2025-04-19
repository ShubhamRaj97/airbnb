Rails.application.routes.draw do
  # get "static/fcm_token"
  devise_for :users
  
  use_doorkeeper
    # get 'fcm_token', to: 'static#fcm_token'

  
  # namespace :api, defaults: { format: :json } do
  #   namespace :v1 do
  #         post 'send_otp', to: 'sms_otp#send_otp'
  #          post 'notifications/send', to: 'notifications#send_notification'

  #     scope :auth, module: :auth do
  #       post "/", to: "registrations#create", as: :auth_registration
  #     end
  #   end
  # end

  namespace :api do
  namespace :v1 do
    namespace :auth do
      post :send_otp, to: 'auth#send_otp'
      post :verify_otp, to: 'auth#verify_otp'
    end
  end
end


end
