class Image < ActiveRecord::Base
  belongs_to :product
  has_attached_file :image, default_url:  "/images/:style/missing.png",
                    storage: :s3, bucket: 'truve',
                    url: '/:image/:id/:style/:basename.:extension',
                    path: ':image/:id/:style/:basename.:extension',
                    s3_credentials: {
                      access_key_id: 'AKIAIGRHS63OKNU5HYNQ',
                      secret_access_key: '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'
                    }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
