class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken', foreign_key: :resource_owner_id

   validates :email, presence: true, unless: -> { phone.present? }
  
  # Skip password validation for phone-only users
    validates :password, presence: true, on: :create, unless: -> { phone.present? }
      validates :phone, uniqueness: true, allow_nil: true



  def self.authenticate(email, password, type)
    # Here, you can add custom logic to check 'type' and validate the user
    user = User.find_by(email: email)
    # Authenticate the user based on password
    if user && user.valid_password?(password)
      user
    else
      nil  # Return nil if authentication fails
    end
  end 

end
