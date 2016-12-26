class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.decimal :price
      t.string :currency
      t.string :image
      t.text :description
      t.string :brand
      t.integer :batch

      t.timestamps null: false
    end
  end
end
