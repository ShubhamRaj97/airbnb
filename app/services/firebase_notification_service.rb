require 'googleauth'
require 'httparty'

class FirebaseNotificationService
  FCM_URL = "https://fcm.googleapis.com/v1/projects/airbnb-9ff4e/messages:send"

  def initialize(service_account_path = "/Users/shubhamraj/Downloads/airbnb-9ff4e-firebase-adminsdk-c7hqu-9a21709acc.json")
    # firebase_service = FirebaseNotificationService.new("/Users/shubhamraj/Downloads/your-service-account.json")

    @service_account_path = service_account_path
  end

  # Method to send a notification using HTTP v1 API
  def send_notification(device_token, title, body, data = {})
    access_token = self.class.get_access_token(@service_account_path)
    binding.pry
    payload = {
      message: {
        token: device_token,
        notification: {
          title: title,
          body: body
        },
        data: data
      }
    }

    headers = {
      "Authorization" => "Bearer #{access_token}",
      "Content-Type" => "application/json"
    }

    begin
      response = HTTParty.post(FCM_URL, headers: headers, body: payload.to_json)
      Rails.logger.info "FCM Response: #{response.parsed_response}"
      response.parsed_response
    rescue StandardError => e
      Rails.logger.error "Error sending FCM notification: #{e.message}"
      { error: e.message }
    end
  end

  # Method to generate an access token using the service account
  def self.get_access_token(service_account_path)
    scope = "https://www.googleapis.com/auth/firebase.messaging"
    authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(service_account_path),
      scope: scope
    )
    authorizer.fetch_access_token!["access_token"]
  end
end
