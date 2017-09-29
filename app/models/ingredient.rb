class Ingredient < ApplicationRecord
  belongs_to :kitchen
  validates_presence_of :name, :amount, :kitchen_id
end
