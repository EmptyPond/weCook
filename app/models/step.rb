class Step < ApplicationRecord
  belongs_to :kitchen
  validates_presence_of :step_num, :description, :kitchen_id
end
