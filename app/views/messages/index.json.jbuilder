json.array!(@messages) do |message|
  json.id message.id
  json.content truncate(message.content, length: 144)
  json.read_at message.read_at.to_s
  json.created_at message.created_at.to_s
  json.updated_at message.updated_at.to_s
  json.url "#{root_url}users/#{@user.id}/messages/conversations/#{message.unique_id}.json"
  json.sender do
    json.id message.sender.id
    json.first_name message.sender.first_name
    json.last_name message.sender.last_name
    json.email message.sender.name
    json.name message.sender.email
    json.avatar_url message.sender.avatar_url
  end
  json.recipient do
    json.id message.recipient.id
    json.first_name message.recipient.first_name.to_s
    json.last_name message.recipient.last_name.to_s
    json.email message.recipient.name.to_s
    json.name message.recipient.email.to_s
    json.avatar_url message.recipient.avatar_url.to_s
  end
end
