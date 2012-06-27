class Ingredient < ActiveRecord::Base
  belongs_to :food
  belongs_to :recipe
  belongs_to :unit

  attr_accessible :food_id
  attr_accessible :unit_id
  attr_accessible :quantity

  validates_numericality_of :quantity, :allow_nil => true

  attr_accessor :selected

  def food_name
    "#{@food.name if @food}"
  end
end
