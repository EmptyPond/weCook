class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, confirmation: true
  validates_presence_of :password, :email
  has_and_belongs_to_many :kitchen
  has_many :recipes, through: :kitchen
end
