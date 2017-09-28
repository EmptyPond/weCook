class CreateKitchensUsersManyTable < ActiveRecord::Migration[5.0]
  def change
    create_table :kitchens_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :kitchen, index: true
    end
  end
end
