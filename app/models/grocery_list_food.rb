class GroceryListFood < ActiveRecord::Base
  self.table_name = "grocery_lists_foods"

  belongs_to :grocery_list
  belongs_to :food

  attr_accessible :food_id
  attr_accessible :quantity
  attr_accessible :unit_name

  validates :food_id, :presence => true
  validates :quantity, :presence => true
  validates_numericality_of :quantity
end