class Product < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :images

  attr_accessor :image_ids

  after_create :image_refs
  after_save   :image_refs

  def primary_image
    image = images.where(kind: 'primary').first
    image ||= images.first
    return nil if image.nil?
    image.image.url
  end

  def comment_count
    comments.count
  end

  def image_refs
    return nil if image_ids.nil?
    image_ids.each do |image_id|
      self.images << Image.find(image_id)
    end
    reload
  end
end
