class Recipe < ApplicationRecord

  belongs_to :kitchens
  has_many :users, through: :kitchens
  has_many :ingredients
  has_many :steps
end
