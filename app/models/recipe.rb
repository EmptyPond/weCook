class Recipe < ApplicationRecord
  has_many :kitchen
  has_many :users, through: :kitchen
  has_many :ingredients
  has_many :steps
end
