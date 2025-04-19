class Api::V1::Auth::AuthController < ApiController
  	include DoorkeeperRegisterable
  skip_before_action :doorkeeper_authorize!, only: %i[send_otp verify_otp]

  def send_otp
    phone = params[:phone]

    if phone.blank?
      render json: { error: 'Phone number is required' }, status: :unprocessable_entity and return
    end

    otp_record = SmsOtp.find_or_initialize_by(phone: phone)
    
    # Prevent generating a new OTP if the last one hasn't expired
    if otp_record.persisted? && !otp_record.expired?
      render json: { message: 'OTP already sent, please wait until it expires', expires_at: otp_record.created_at }, status: :ok
    else
      otp_record.destroy if otp_record.persisted?
      otp_record = SmsOtp.create!(phone: phone)

      # Use your TextbeltService to send OTP
      response = TwilioService.new.send_sms(phone, "Your OTP is #{otp_record.otp}")

      if response
        render json: { message: 'OTP sent successfully', expires_at: otp_record.created_at }, status: :ok
      else
        render json: { error: response['error'] || 'Failed to send OTP' }, status: :unprocessable_entity
      end
    end
  end

  # def verify_otp
  #   phone = params[:phone]
  #   entered_otp = params[:otp]
  #   uid = params[:client_id]

  #    # Generate tokens and render user
  #     client_app = Doorkeeper::Application.find_by(uid: uid)
  #     	unless client_app
	# 		return render json: { error: I18n.t("doorkeeper.errors.messages.invalid_client") }, status: :unauthorized
	# 	end

	# 	 if !validate_password_strength(params[:password])
	# 	    render json: { msg: "Password does not meet strength requirements.Use capital letter,special character and number" }, status: :unprocessable_entity
	# 	    return
	# 	  end

  #   if phone.blank? || entered_otp.blank?
  #     render json: { error: 'Phone and OTP are required' }, status: :unprocessable_entity and return
  #   end

  #   otp_record = SmsOtp.find_by(phone: phone)

  #   if otp_record&.verify(entered_otp)
  #     otp_record.update!(verified: true)

  #       allowed_params = user_params.except(:client_id)
	# 	user = User.new(allowed_params)
		
	# 	if user.save
	# 		render json: render_user(user, client_app), status: :ok     
	# 	else 
	# 		user =  User.find_by(email: params[:email])
	# 	  if user.present? 
	# 		  render json: { error: "email has already taken" }, status: :unprocessable_entity 
	# 	  else 
	# 	 	  render json: { error: "Please sign in to continue sign up" }, status: :unprocessable_entity
	# 	  end
	#   	end
  #   else
  #     render json: { error: 'Invalid or expired OTP' }, status: :unauthorized
  #   end
  # end

  def verify_otp
	  phone = params[:phone]
	  entered_otp = params[:otp]

	  if phone.blank? || entered_otp.blank?
	    render json: { error: 'Phone and OTP are required' }, status: :unprocessable_entity and return
	  end

		client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
    unless client_app
			return render json: { error: I18n.t("doorkeeper.errors.messages.invalid_client") }, status: :unauthorized
		end

	  otp_record = SmsOtp.find_by(phone: phone)

	  if otp_record&.verify(entered_otp)
	    otp_record.update!(verified: true)

	    # Find or create the user by phone number
	    user = User.new(phone: phone)
    	user.save(validate: false)

	    response_data = render_user(user, client_app)
	    render json: { message: 'Login successful!', user: response_data }, status: :ok
	  else
	    render json: { error: 'Invalid or expired OTP' }, status: :unauthorized
	  end
	end



  private


  def allowed_params
  	params.permit(:email, :password, :password_confirmation, :client_id, :phone)
  end

  def validate_password_strength(password)
	    regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\W).{8,}$/
	    regex.match?(password)
  end



























end
