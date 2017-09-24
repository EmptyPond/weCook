class Recipe < ApplicationRecord

  has_many :kitchens
  has_many :users, through: :kitchens
  has_many :ingredients
  has_many :steps
end
