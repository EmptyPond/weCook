class Recipe < ApplicationRecord
  has_many :kitchen
  validates_presence_of :name, :description
end
