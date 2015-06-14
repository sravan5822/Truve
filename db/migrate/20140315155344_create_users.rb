class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :fb_oauth_token
      t.string :fb_refresh_token
      t.string :fb_user_id
      t.string :email
      t.string :gender
      t.date :birthday
      t.string :time
      t.string :city
      t.string :country
      t.text :avatar_url
      t.text :meta
      t.boolean :recieve_emails
      t.boolean :share_with_friends_of_friends
      t.text :friends_of_friends_hash

      t.timestamps
    end
  end
end
