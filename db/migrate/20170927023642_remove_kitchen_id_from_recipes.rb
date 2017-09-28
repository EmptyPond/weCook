class RemoveKitchenIdFromRecipes < ActiveRecord::Migration[5.0]
  def change
    remove_column :recipes, :kitchen_id
  end
end
