class Ingredient < ActiveRecord::Base
  belongs_to :food
  belongs_to :recipe
  belongs_to :unit

  validates_numericality_of :quantity, :allow_nil => true

  attr_accessor :selected
end
