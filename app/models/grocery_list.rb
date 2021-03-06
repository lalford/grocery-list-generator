require 'ruby-units'

class GroceryList < ActiveRecord::Base
  has_many :grocery_list_recipes, dependent: :destroy
  has_many :recipes, :through => :grocery_list_recipes

  has_many :grocery_list_foods, dependent: :destroy
  has_many :foods, :through => :grocery_list_foods

  accepts_nested_attributes_for :grocery_list_recipes, allow_destroy: true, :reject_if => proc { |attributes| attributes['recipe_id'].blank? }
  accepts_nested_attributes_for :grocery_list_foods, allow_destroy: true, :reject_if => proc { |attributes| attributes['food_id'].blank? }

  validates :name, :presence => true
  validates_uniqueness_of :name

  attr_accessible :name
  attr_accessible :grocery_list_recipes_attributes
  attr_accessible :grocery_list_foods_attributes

  # user entered email, if populated the generate list action will also send an email
  attr_accessor :to_email
  attr_accessible :to_email
  validates :to_email, :email => true, :allow_nil => true, :allow_blank => true

  # produce a hash of foods to purchase for the generated list, grouped by store section
  NO_SECTION_KEY = "No Section"
  QUANTITY_KEY = "quantity"
  UNIT_NAME_KEY = "unit name"
  def generate
    generated_list = {}

    # add foods from recipe ingredients
    grocery_list_recipes.each do |glr|
      desired_servings = glr.quantity ? glr.quantity : 1
      recipe = glr.recipe
      recipe_servings = recipe.servings ? recipe.servings : 1
      recipe.ingredients.each do |ingredient|
        desired_servings = 1 if !desired_servings
        ingredient_quantity = ingredient.quantity ? ingredient.quantity : 0
        single_serving_ingredient_quantity = ingredient_quantity / recipe_servings
        quantity = (desired_servings * single_serving_ingredient_quantity)
        merge_purchase_items(generated_list, ingredient.food, quantity, ingredient.unit_name)
      end if recipe and recipe.ingredients
    end if grocery_list_recipes

    # add a la carte foods
    grocery_list_foods.each do |glf|
      food_quantity = glf.quantity ? glf.quantity : 0
      merge_purchase_items(generated_list, glf.food, food_quantity, glf.unit_name)
    end if grocery_list_foods

    generated_list
  end

  private

  def set_store_section_display_name(food)
    if food.store_section and food.store_section.name and !food.store_section.name.blank?
      store_section_name = food.store_section.name
    else
      store_section_name = NO_SECTION_KEY
    end
    store_section_name
  end

  def build_food_item_hash(food_name, quantity, unit_name)
    { food_name => { QUANTITY_KEY => quantity.to_s, UNIT_NAME_KEY => unit_name } }
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
        u1 = current_food_info[UNIT_NAME_KEY]
        u2 = next_food_info[UNIT_NAME_KEY]
        if u1.blank? and u2.blank?
          new_food_info = add_quantities(food_name, current_food_info, next_food_info)
        elsif !u1.blank? and !u2.blank?
          if Unit(u1) =~ Unit(u2)
            new_food_info = add_quantities(food_name, current_food_info, next_food_info)
          else
            new_food_info = build_mismatched_quantity_and_unit_strings(food_name, current_food_info, next_food_info)
          end
        else
          new_food_info = build_mismatched_quantity_and_unit_strings(food_name, current_food_info, next_food_info)
        end
        new_food_info
      }
    }
  end

  private

  def add_quantities(food_name, current_food_info, next_food_info)
    puts "for food #{food_name}, adding additional quantity #{next_food_info[QUANTITY_KEY]} to current quantity #{current_food_info[QUANTITY_KEY]}"
    unit_result = (make_unit(current_food_info) + make_unit(next_food_info)).to_s
    { QUANTITY_KEY => unit_result.split[0], # only take the quantity portion of the Unit object's string
      UNIT_NAME_KEY => current_food_info[UNIT_NAME_KEY] }
  end

  def build_mismatched_quantity_and_unit_strings(food_name, current_food_info, next_food_info)
    puts "for food #{food_name}, cannot convert unit #{next_food_info[UNIT_NAME_KEY]} to #{current_food_info[UNIT_NAME_KEY]}"
    u1 = current_food_info[UNIT_NAME_KEY].blank? ? "n/a" : current_food_info[UNIT_NAME_KEY]
    u2 = next_food_info[UNIT_NAME_KEY].blank? ? "n/a" : next_food_info[UNIT_NAME_KEY]
    { QUANTITY_KEY => "#{current_food_info[QUANTITY_KEY]} + #{next_food_info[QUANTITY_KEY]}",
      UNIT_NAME_KEY => "#{u1} + #{u2}" }
  end
end
