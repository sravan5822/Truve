class FixTypoOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :recieve_emails, :receive_emails
  end
end
