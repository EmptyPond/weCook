class Kitchens < ActiveRecord::Migration[5.0]
  def change
    create_table :kitchens do |t|
      t.integer :user_id
      t.integer :recipe_id
  end
end
