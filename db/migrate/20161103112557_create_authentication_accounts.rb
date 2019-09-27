class CreateAuthenticationAccounts < ActiveRecord::Migration[4.2][4.2]
  def change
    create_table :authentication_accounts do |t|
      t.string            :email, unique: true
      t.string            :encrypted_password
      t.string            :gid
      t.text              :roles, :null => false
      t.timestamps
    end
  end
end
