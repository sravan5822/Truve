class AddFriendsArrayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :friends_array, :text
  end
end
