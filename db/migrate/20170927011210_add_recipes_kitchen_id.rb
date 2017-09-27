class AddRecipesKitchenId < ActiveRecord::Migration[5.0]
  def change
    add_column :recipes, :kitchen_id, :integer
  end
end
