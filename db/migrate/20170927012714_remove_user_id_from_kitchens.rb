class RemoveUserIdFromKitchens < ActiveRecord::Migration[5.0]
  def change
    remove_column :kitchens, :user_id
  end
end
