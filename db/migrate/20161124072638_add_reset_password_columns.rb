class AddResetPasswordColumns < ActiveRecord::Migration[4.2]
  def change
    add_column :authentication_accounts, :reset_password_token, :string, after: :roles
    add_column :authentication_accounts, :reset_password_expires_at, :datetime, after: :reset_password_token
  end
end
