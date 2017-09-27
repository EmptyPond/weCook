class Kitchen < ApplicationRecord
  has_and_belongs_to_many :user
  belongs_to :recipe
end
