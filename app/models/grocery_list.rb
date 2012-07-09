class GroceryList < ActiveRecord::Base
  has_many :grocery_list_recipes, dependent: :destroy
  has_many :recipes, :through => :grocery_list_recipes

  has_many :grocery_list_foods, dependent: :destroy
  has_many :foods, :through => :grocery_list_foods

  accepts_nested_attributes_for :grocery_list_recipes, allow_destroy: true
  accepts_nested_attributes_for :grocery_list_foods, allow_destroy: true

  validates :name, :presence => true
  validates_uniqueness_of :name

  attr_accessible :name
  attr_accessible :grocery_list_recipes_attributes
  attr_accessible :grocery_list_foods_attributes

  # produce a hash of foods to purchase for the generated list
  # {
  #   "food name 1" => {
  #     "quantity" => quantity1,
  #     "unit_name" => "unit name 1" },
  #   "food name 2" => {
  #     "quantity" => quantity2,
  #     "unit_name" => "unit name 2" },
  #   ...
  # }
  def generate
    generated_list = {}

    # add foods from recipe ingredients
    grocery_list_recipes.each do |glr|
      recipe_quantity = glr.quantity
      recipe = glr.recipe
      recipe.ingredients.each do |ingredient|
        generated_list = generated_list.merge(build_food_item_hash(ingredient.food.name, (recipe_quantity * ingredient.quantity), ingredient.unit)) {
          |food_name, current_food_info, next_food_info|
          # TODO - check units, implement conversions
          puts "for food #{food_name}, adding additional quantity #{next_food_info["quantity"]} to current quantity #{current_food_info["quantity"]}"
          current_food_info["quantity"] + next_food_info["quantity"]
        }
      end
    end if grocery_list_recipes

    # add a la carte foods
    grocery_list_foods.each do |glf|
      generated_list = generated_list.merge(build_food_item_hash(glf.food.name, glf.quantity, glf.unit)) { |food_name, current_food_info, next_food_info|
        # TODO - check units, implement conversions
        puts "for food #{food_name}, adding additional quantity #{next_food_info["quantity"]} to current quantity #{current_food_info["quantity"]}"
        current_food_info["quantity"] + next_food_info["quantity"]
      }
    end if grocery_list_foods

    generated_list
  end

  private

  def build_food_item_hash(food_name, quantity, unit)
    unit_name = unit.long_name if unit
    { food_name => { "quantity" => quantity, "unit_name" => unit_name } }
  end
end
