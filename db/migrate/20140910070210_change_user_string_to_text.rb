class ChangeUserStringToText < ActiveRecord::Migration
  def change
    change_column :users, :fb_oauth_token,  :text
    change_column :users, :fb_refresh_token,  :text
  end
end
