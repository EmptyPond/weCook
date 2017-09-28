class RemoveRecipeIdFromKitchens < ActiveRecord::Migration[5.0]
  def change
    remove_column :kitchens, :recipe_id 
  end
end
