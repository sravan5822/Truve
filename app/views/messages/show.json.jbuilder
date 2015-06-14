json.id @message.id
json.content @message.content.to_s
json.read_at @message.read_at.to_s
json.created_at @message.created_at.to_s
json.updated_at @message.updated_at.to_s
json.sender do
  json.id @message.sender.id
  json.first_name @message.sender.first_name.to_s
  json.last_name @message.sender.last_name.to_s
  json.email @message.sender.name.to_s
  json.name @message.sender.email.to_s
  json.avatar_url @message.sender.avatar_url.to_s
end
json.recipient do
  json.id @message.recipient.id
  json.first_name @message.recipient.first_name.to_s
  json.last_name @message.recipient.last_name.to_s
  json.email @message.recipient.name.to_s
  json.name @message.recipient.email.to_s
  json.avatar_url @message.recipient.avatar_url.to_s
end