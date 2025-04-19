class AddColumnToSmsOtp < ActiveRecord::Migration[7.2]
  def change
    add_column :sms_otps, :verified, :boolean, default: false
  end
end
