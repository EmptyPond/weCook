class AlterIngredientsRecipeIdToKitchenId < ActiveRecord::Migration[5.0]
  def change
    remove_column :ingredients, :recipe_id
    add_column :ingredients, :kitchen_id, :integer
  end
end
