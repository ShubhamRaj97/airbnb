class Api::V1::SmsOtpController < ApiController
  skip_before_action :doorkeeper_authorize!, only: [:send_otp]

  def send_otp
    phone = params[:phone]

    if phone.blank?
      render json: { error: "Phone number is required" }, status: :unprocessable_entity
      return
    end

    otp = rand(100000..999999)

    # Use SmsOtp model to create the OTP entry
    SmsOtp.create(phone: phone, otp: otp)

    # Find or create the user
    user = User.find_or_initialize_by(phone: phone)
    user.save if user.new_record?

    # Send the OTP using Twilio
    TwilioService.new.send_message(phone, "Your OTP is #{otp}")

    render json: { message: "OTP sent successfully" }, status: :ok
  end

  # def send_otp
  #   phone = params[:phone] # Expecting phone number in the params
  #   message = params[:message] # Expecting message text in the params

  #   # Call the TextbeltService
  #   response = TextbeltService.new.send_sms(phone, message)

  #   if response['success']
  #     render json: { status: 'success', message: 'SMS sent successfully', quota_remaining: response['quotaRemaining'] }, status: :ok
  #   else
  #     render json: { status: 'error', message: response['error'] || 'Failed to send SMS' }, status: :unprocessable_entity
  #   end
  # end
end
