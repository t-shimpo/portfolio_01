class RemoveImpressionFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :impression, :integer
  end
end
