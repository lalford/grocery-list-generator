class Ingredient < ActiveRecord::Base
  belongs_to :food
  belongs_to :recipe
  belongs_to :unit

  validates :quantity, :presence => true

  attr_accessor :selected
end
