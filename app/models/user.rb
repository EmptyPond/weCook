class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, confirmation: true
  has_many :kitchens
  has_many :recipes, through: :kitchens
end
