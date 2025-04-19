class CreateSmsOtp < ActiveRecord::Migration[7.2]
  def change
    create_table :sms_otps do |t|
      t.string :phone
      t.string :otp

      t.timestamps
    end
  end
end
