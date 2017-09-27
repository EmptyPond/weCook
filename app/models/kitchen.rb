class Kitchen < ApplicationRecord
  has_and_belongs_to_many :user
  belongs_to :recipe
  has_many :ingredients
  has_many :steps
end
