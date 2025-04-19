class SmsOtp < ApplicationRecord

  before_create :set_expiration, :generate_otp
  # Validations
  validates :phone, presence: true, format: { with: /\A\d{10,15}\z/, message: "must be a valid phone number" }
  # validates :otp, presence: true
  # validates :expires_at, presence: true

  # Check if the OTP is expired
  def expired?
    Time.current > created_at
  end

  def verify(entered_otp)
    !expired? && otp == entered_otp && !verified?
  end

  private

  def set_expiration
    self.created_at = 5.minutes.from_now
  end

  def generate_otp
    self.otp = rand(100000..999999).to_s # Generate a 6-digit OTP
  end

end
