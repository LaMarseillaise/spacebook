class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false, index: true, unique: true
      t.string :password_digest, null: false, index: true
      t.string :gender
      t.date   :birthday
      t.string :auth_token, index: true, unique: true

      t.timestamps
    end
  end
end
