class GroceryListRecipe < ActiveRecord::Base
  self.table_name = "grocery_lists_recipes"

  belongs_to :grocery_list
  belongs_to :recipe

  attr_accessible :recipe_id
  attr_accessible :quantity

  validates_numericality_of :quantity, :allow_nil => true
end
