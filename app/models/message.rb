class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  attr_accessor :unique_id

  default_scope -> { order('created_at DESC') }
end
