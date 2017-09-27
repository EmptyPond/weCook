class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, confirmation: true
  has_and_belongs_to_many :kitchen
  has_many :recipes, through: :kitchen
end
