class RemoveFriendsColumnFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :friends_array
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
