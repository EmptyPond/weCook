class AlterStepsRecipeIdToKitchenId < ActiveRecord::Migration[5.0]
  def change
    remove_column :steps, :recipe_id
    add_column :steps, :kitchen_id, :integer
  end
end
