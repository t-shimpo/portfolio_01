class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :post_image
      t.string :title,        null: false
      t.string :author,       null: false
      t.string :publisher
      t.integer :genre
      t.integer :rating
      t.integer :impression
      t.integer :hours
      t.date :purchase_date
      t.text :post_content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :posts, %i[user_id created_at]
  end
end
