require 'ruby-units'

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

  # produce a hash of foods to purchase for the generated list, grouped by store section
  NO_SECTION_KEY = "No Section"
  QUANTITY_KEY = "quantity"
  UNIT_NAME_KEY = "unit name"
  def generate
    generated_list = {}

    # add foods from recipe ingredients
    grocery_list_recipes.each do |glr|
      recipe_quantity = glr.quantity
      recipe = glr.recipe
      recipe.ingredients.each do |ingredient|
        puts "before default, recipe quantity = #{recipe_quantity}"
        puts "before default, ingredient quantity = #{ingredient.quantity}"
        recipe_quantity = 1 if !recipe_quantity
        ingredient_quantity = ingredient ? ingredient.quantity : 1
        puts "after default, recipe quantity = #{recipe_quantity}"
        puts "after default, ingredient quantity = #{ingredient_quantity}"

        quantity = (recipe_quantity * ingredient_quantity)
        merge_purchase_items(generated_list, ingredient.food, quantity, ingredient.unit_name)
      end if recipe and recipe.ingredients
    end if grocery_list_recipes

    # add a la carte foods
    grocery_list_foods.each do |glf|
      merge_purchase_items(generated_list, glf.food, glf.quantity, glf.unit_name)
    end if grocery_list_foods

    generated_list
  end

  private

  def set_store_section_display_name(food)
    puts "food = #{food}"
    if food.store_section and food.store_section.name and !food.store_section.name.blank?
      store_section_name = food.store_section.name
    else
      store_section_name = NO_SECTION_KEY
    end
    store_section_name
  end

  def build_food_item_hash(food_name, quantity, unit_name)
    { food_name => { QUANTITY_KEY => quantity, UNIT_NAME_KEY => unit_name } }
  end

  def build_store_section_hash(food, quantity, unit_name)
    store_section_name = set_store_section_display_name(food)
    { store_section_name => build_food_item_hash(food.name, quantity, unit_name) }
  end

  def make_unit(food_info)
    Unit "#{food_info[QUANTITY_KEY]} #{food_info[UNIT_NAME_KEY]}"
  end

  def merge_purchase_items(current_list, food, quantity, unit_name)
    current_list.merge!(build_store_section_hash(food, quantity, unit_name)) { |store_section_name, current_section_food_hash_set, next_section_food_hash_set|
      current_section_food_hash_set.merge(next_section_food_hash_set) { |food_name, current_food_info, next_food_info|
        if Unit(current_food_info[UNIT_NAME_KEY]) =~ Unit(next_food_info[UNIT_NAME_KEY])
          puts "for food #{food_name}, adding additional quantity #{next_food_info[QUANTITY_KEY]} to current quantity #{current_food_info[QUANTITY_KEY]}"
          unit_result = (make_unit(current_food_info) + make_unit(next_food_info)).to_s
          new_food_info = {
            QUANTITY_KEY => unit_result.split[0], # only take the quantity portion of the Unit object's string
            UNIT_NAME_KEY => current_food_info[UNIT_NAME_KEY] }
        else
          puts "for food #{food_name}, cannot convert unit #{next_food_info[UNIT_NAME_KEY]} to #{current_food_info[UNIT_NAME_KEY]}"
          new_food_info = { QUANTITY_KEY => "#{current_food_info[QUANTITY_KEY]} + #{next_food_info[QUANTITY_KEY]}",
            UNIT_NAME_KEY => "#{current_food_info[UNIT_NAME_KEY]} + #{next_food_info[UNIT_NAME_KEY]}" }
        end
        puts "new food info:\n#{new_food_info}"
        new_food_info
      }
    }
  end
end
