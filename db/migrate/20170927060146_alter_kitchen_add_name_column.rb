class AlterKitchenAddNameColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :kitchens, :name, :string
  end
end
