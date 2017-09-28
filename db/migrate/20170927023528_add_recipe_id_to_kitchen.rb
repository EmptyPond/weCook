class AddRecipeIdToKitchen < ActiveRecord::Migration[5.0]
  def change
    add_column :kitchens, :recipe_id, :integer
  end
end
