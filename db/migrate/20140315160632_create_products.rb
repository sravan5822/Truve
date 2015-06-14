class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.string :brand
      t.string :condition
      t.integer :user_id

      t.timestamps
    end

    add_index :products, :user_id
  end
end
