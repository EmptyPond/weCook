class Steps < ActiveRecord::Migration[5.0]
  def change
    create_table :steps do |t|
      t.integer :step_num
      t.text :description
      t.integer :recipe_id
    end
  end
end
