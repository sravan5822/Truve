class CreateImages < ActiveRecord::Migration
  def up
    create_table :images do |t|
      t.integer :product_id
      t.string :kind

      t.timestamps
    end

    add_attachment :images, :image
  end

  def down
    remove_attachment :images, :image
  end
end
