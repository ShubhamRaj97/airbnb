class Api::V1::NotificationsController < ApiController
skip_before_action :doorkeeper_authorize!, only: [:send_notification]

  def send_notification
    firebase_service = FirebaseNotificationService.new("/Users/shubhamraj/Downloads/airbnb-9ff4e-firebase-adminsdk-c7hqu-9a21709acc.json")

    # Parameters from the request
    device_token = params[:device_token]
    title = params[:title]
    body = params[:body]
    data = params[:data] || {}

    # Send the notification
    response = firebase_service.send_notification([device_token], title, body, data)

    render json: { success: true, response: response }, status: :ok
  rescue StandardError => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
end
