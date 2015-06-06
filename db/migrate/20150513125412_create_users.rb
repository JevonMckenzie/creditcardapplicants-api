# create user table
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, unique: true
      # password related
      t.string :hashed_password, null: false
      t.string :password_salt, null: false
      t.string :email, null: false

      t.string :fullname, null: false
      t.string :fullname_nonce, null: false

      t.text :address, null: false
      t.string :address_nonce, null: false

      t.string :dob, null: false
      t.string :dob_nonce, null: false

    end
  end
end
