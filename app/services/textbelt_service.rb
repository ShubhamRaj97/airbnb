# require 'net/http'
# require 'uri'
# require 'json'

# # class TextbeltService
# #   TEXTBELT_API_URL = 'https://textbelt.com/text'.freeze

# #   def initialize
# #     @api_key = ENV['TEXTBELT_SERVICE_KEY'] || 'textbelt' # Replace 'textbelt' with your private key if available
# #   end

# #   def send_sms(phone, message)
# #     uri = URI.parse(TEXTBELT_API_URL)
# #     response = Net::HTTP.post_form(uri, {
# #       phone: phone,
# #       message: message,
# #       key: @api_key
# #     })

# #     response_body = JSON.parse(response.body)
# #     if response_body['success']
# #       Rails.logger.info "SMS sent successfully to #{phone}"
# #       response_body
# #     else
# #       Rails.logger.error "Failed to send SMS to #{phone}: #{response_body['error']}"
# #       response_body
# #     end
# #   rescue StandardError => e
# #     Rails.logger.error "Error while sending SMS: #{e.message}"
# #     { 'success' => false, 'error' => e.message }
# #   end
# # end

# class TextbeltService
#   include HTTParty
#   base_uri 'https://textbelt.com'

#   def initialize
#     @api_key = ENV['TEXTBELT_API_KEY']
#   end

#   def send_sms(phone, message)
#     response = self.class.post('/text', body: {
#       phone: phone,
#       message: message,
#       key: @api_key
#     })

#     JSON.parse(response.body)
#   rescue StandardError => e
#     Rails.logger.error "Failed to send SMS: #{e.message}"
#     { 'success' => false, 'error' => 'An error occurred while sending SMS' }
#   end
# end

