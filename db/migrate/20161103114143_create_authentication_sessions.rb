class CreateAuthenticationSessions < ActiveRecord::Migration[4.2][4.2]
  def change
    create_table :authentication_sessions do |t|
      t.integer         :account_id, null: false, index: true
      t.string          :authentication_token, null: false, index: true, unique: true
      t.string          :ip
      t.integer         :status, default: Authentication::Session.statuses[:active], null: false
      t.text            :meta_info
      t.timestamps
    end
  end
end
