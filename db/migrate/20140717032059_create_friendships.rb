class CreateFriendships < ActiveRecord::Migration
  def change
    create_table :friendships, id: false do |t|
      t.string :origin
      t.string :friend
    end

    add_index :friendships, :origin
    add_index :friendships, :friend
    add_index :friendships, [:origin, :friend], unique: true
  end
end