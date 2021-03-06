class Ingredient < ActiveRecord::Base
  belongs_to :food
  belongs_to :recipe

  attr_accessible :food_id
  attr_accessible :quantity
  attr_accessible :unit_name

  validates_numericality_of :quantity, :allow_nil => true
end
