json.id @product.id
json.title @product.title.to_s
json.description @product.description.to_s
json.price @product.price.to_s
json.brand @product.brand.to_s
json.condition @product.condition.to_s
json.primary_image @product.primary_image
json.comment_count @product.comment_count
json.url product_url(@product, format: :json)
json.created_at @product.created_at.to_s
json.updated_at @product.updated_at.to_s
json.images @product.images do |image|
  json.id image.id
  json.kind image.kind.to_s
  json.url image.image.url.to_s
  json.created_at image.created_at.to_s
  json.updated_at image.updated_at.to_s
end
json.owner do
  json.id @product.user.id
  json.fist_name @product.user.first_name.to_s
  json.last_name @product.user.last_name.to_s
  json.name @product.user.name.to_s
  json.email @product.user.email.to_s
  json.avatar_url @product.user.avatar_url.to_s
end
json.comments @product.comments do |comment|
  json.extract! comment, :id, :user_id, :content, :created_at, :updated_at
  json.user do
    json.id comment.user.id
    json.first_name comment.user.first_name.to_s
    json.last_name comment.user.last_name.to_s
    json.name comment.user.name.to_s
    json.email comment.user.email.to_s
    json.avatar_url comment.user.avatar_url.to_s
  end
end