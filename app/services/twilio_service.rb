class TwilioService
  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
    @from = ENV['TWILIO_PHONE_NUMBER']
    validate_credentials!
  end

   def send_sms(phone, message)
    response = HTTParty.post('https://textbelt.com/text', {
      body: {
        phone: phone,
        message: message,
        key: 'your-textbelt-api-key'
      }
    })

    # Response will directly be a Hash, and you can check 'success' as needed
    response.parsed_response
  rescue StandardError => e
    Rails.logger.error("Failed to send SMS: #{e.message}")
    { "success" => false, "error" => "Service error: #{e.message}" }
  end

  def send_whatsapp_message(to, body)
    @client.messages.create(
      from: "whatsapp:#{@from}",
      to: "whatsapp:#{to}",
      body: body
    )
  rescue Twilio::REST::RestError => e
    Rails.logger.error "Twilio WhatsApp Error: #{e.message}"
    false
  end

  private

  def validate_credentials!
    missing_credentials = []
    missing_credentials << "TWILIO_ACCOUNT_SID" unless ENV['TWILIO_ACCOUNT_SID']
    missing_credentials << "TWILIO_AUTH_TOKEN" unless ENV['TWILIO_AUTH_TOKEN']
    missing_credentials << "TWILIO_PHONE_NUMBER" unless ENV['TWILIO_PHONE_NUMBER']

    unless missing_credentials.empty?
      raise "Missing Twilio credentials: #{missing_credentials.join(', ')}"
    end
  end
end
