class Api::V1::Auth::RegistrationsController < ApiController
	skip_before_action :doorkeeper_authorize!, only: %i[create]

	include DoorkeeperRegisterable

	def create
		client_app = Doorkeeper::Application.find_by(uid: user_params[:client_id])
		 if !validate_password_strength(params[:password])
		    render json: { msg: "Password does not meet strength requirements.Use capital letter,special character and number" }, status: :unprocessable_entity
		    return
		  end

		unless client_app
			return render json: { error: I18n.t("doorkeeper.errors.messages.invalid_client") }, status: :unauthorized
		end

		allowed_params = user_params.except(:client_id)
		user = User.new(allowed_params)
		
		if user.save
			render json: render_user(user, client_app), status: :ok   
		  
		else 
			user =  User.find_by(email: params[:email])
		  if user.present? 
			  render json: { error: "email has already taken" }, status: :unprocessable_entity 
		  else 
		 	  render json: { error: "Please sign in to continue sign up" }, status: :unprocessable_entity
		  end
	  end
	end

	private

	def user_params
		params.permit(:email, :password, :password_confirmation, :client_id)
	end

	def validate_password_strength(password)
	    regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*\W).{8,}$/
	    regex.match?(password)
	end
end
