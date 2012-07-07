class GroceryListFood < ActiveRecord::Base
  self.table_name = "grocery_lists_foods"

  belongs_to :grocery_list
  belongs_to :food
  belongs_to :unit

  attr_accessible :food_id
  attr_accessible :unit_id
  attr_accessible :quantity

  validates_numericality_of :quantity, :allow_nil => true
end