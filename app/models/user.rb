class User < ActiveRecord::Base
  has_many :products
  has_many :comments
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :recieved_messages, class_name: 'Message', foreign_key: 'recipient_id'
  has_many :friendships, foreign_key: 'origin'

  # TODO: Make default image for users who dont have an avatar url.


  # Other Methods
  def fetch_friends
    koala   = Koala::Facebook::API.new self.fb_oauth_token
    friends = koala.get_connections 'me', 'friends'
    friends = friends.map { |friend| friend["id"].to_i }

    sql = "SELECT *
           FROM friendships
           WHERE origin = '#{self.fb_user_id}'"
    existing = ActiveRecord::Base.connection.execute(sql).map { |f| f['friend'].to_i }

    friends.each do |friend|
      next if existing.include? friend

      f = Friendship.new
      f.origin = self.fb_user_id
      f.friend = friend
      f.save

      # Works hot for SQLite, not so much Postgres
      # sql =  "INSERT OR IGNORE INTO friendships (origin, friend)
      #         VALUES (#{self.fb_user_id}, #{friend})"
      # ActiveRecord::Base.connection.execute(sql)
    end
  end

  def friends
    fb_friends = Friendship.where(origin: self.fb_user_id).pluck(:friend)
    User.where(fb_user_id: fb_friends)
  end

  def friends_all
    fb_friends = Friendship.where(origin: self.fb_user_id).pluck(:friend)
  end

  # def friends_of_friends
  #   f_of_f = []

  #   friends.each do |user|
  #     f_of_f.append(user.friends)
  #   end

  #   return f_of_f.flatten.select{|user| user.id != self.id}
  # end

  def friends_of_friends
    sql = "SELECT users.*, 2 as degrees
           FROM friendships f1
           JOIN friendships f2
           ON (f2.origin = f1.friend AND f2.friend !=  '#{self.fb_user_id}')
           JOIN users ON users.fb_user_id = f2.friend
           WHERE f1.origin = '#{self.fb_user_id}'"
    User.find_by_sql sql
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.fb_user_id = auth["uid"]
      user.fb_oauth_token = auth["credentials"]["token"]
      user.name = auth["info"]["name"] rescue ''
      user.email = auth["info"]["email"] rescue ''
      user.avatar_url = auth["info"]["image"] rescue ''
    end
  end
end
