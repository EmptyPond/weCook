class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, confirmation: true
  has_and_belongs_to_many :kitchens
  has_many :recipes, through: :kitchens
end
