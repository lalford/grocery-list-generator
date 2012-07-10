require 'test_helper'

class GroceryListTest < ActiveSupport::TestCase
  test "should create a new grocery list" do
    grocery_list = GroceryList.new
    grocery_list.name = "fake list"
    assert grocery_list.save, "failed to save #{grocery_list.name}"
  end

  test "should fail to create a grocery list with an existing name" do
    grocery_list = GroceryList.new
    grocery_list.name = grocery_lists(:l1).name
    assert !grocery_list.save, "should not save grocery list with existing name"
  end

  test "should fail to create a grocery list with no name" do
    grocery_list = GroceryList.new
    assert !grocery_list.save, "should not save grocery list without a name"
  end

  test "should create a new grocery list with the food plums and the recipe stuffed salmon" do
    grocery_list = GroceryList.new { |l|
      l.name = "a test list"
    }
    grocery_list_food1 = GroceryListFood.new { |glf|
      glf.grocery_list = grocery_lists(:l1)
      glf.food = foods(:plum)
      glf.quantity = 2
      glf.unit = units(:bag)
    }
    grocery_list_recipe1 = GroceryListRecipe.new { |glr|
      glr.grocery_list = grocery_lists(:l1)
      glr.recipe = recipes(:stuffed_salmon)
      glr.quantity = 3
    }
    grocery_list.grocery_list_foods = [grocery_list_food1]
    grocery_list.grocery_list_recipes = [grocery_list_recipe1]
    assert grocery_list.save, "failed to save grocery list #{grocery_list.name}"
  end

  # TODO - add conversions for units to get rid of the silly string formatting
  # Current example:
  #
  # l1:
  #   recipes:
  #     stuffed_salmon (2):
  #       salmon, 2, filet
  #       spinach, .5, bag
  #       sundried tomato, .5, tablespoon
  #       pine nuts, .5, bag
  #       pesto, 8, tablespoon
  #   foods:
  #     pine nuts, 10, ounce
  #     plum, 3, nil
  #     spinach, 1, bag
  #
  # generated_list:
  #   pesto, 16, tablespoon
  #   pine nuts, 1 + 10, bag + ounce
  #   plum, 3, blank
  #   salmon, 4, filet
  #   spinach, 2, bag
  #   sundried tomato, 1, tablespoon
  #
  test "should generate the grocery list hash from fixture data" do
    grocery_list = grocery_lists(:l1)
    generated_list = grocery_list.generate
    assert_not_nil generated_list, "should have built a grocery list"
    assert_equal 6, generated_list.keys.count, "should have had 6 foods in the list"
    puts "whole generated list:\n#{generated_list}"
    generated_list.keys.each do |food_name|
      puts "food key = #{food_name}"
      case food_name
        when foods(:pesto).name
          assert_equal 16, generated_list[food_name][GroceryList::QUANTITY_KEY], "expected quantities to match"
          assert_equal units(:tbsp).long_name, generated_list[food_name][GroceryList::UNIT_NAME_KEY], "expected unit name to match"
        when foods(:pine_nuts).name
          assert_equal "1.0 + 10.0", generated_list[food_name][GroceryList::QUANTITY_KEY], "expected quantities to match"
          assert_equal "#{units(:bag).short_name} + #{units(:oz).long_name}", generated_list[food_name][GroceryList::UNIT_NAME_KEY], "expected unit name to match"
        when foods(:plum).name
          assert_equal 3, generated_list[food_name][GroceryList::QUANTITY_KEY], "expected quantities to match"
          assert_blank generated_list[food_name][GroceryList::UNIT_NAME_KEY], "expected no unit"
        when foods(:salmon).name
          assert_equal 4, generated_list[food_name][GroceryList::QUANTITY_KEY], "expected quantities to match"
          assert_equal units(:filet).short_name, generated_list[food_name][GroceryList::UNIT_NAME_KEY], "expected unit name to match"
        when foods(:spinach).name
          assert_equal 2, generated_list[food_name][GroceryList::QUANTITY_KEY], "expected quantities to match"
          assert_equal units(:bag).short_name, generated_list[food_name][GroceryList::UNIT_NAME_KEY], "expected unit name to match"
        when foods(:sundried_tomato).name
          assert_equal 1, generated_list[food_name][GroceryList::QUANTITY_KEY], "expected quantities to match"
          assert_equal units(:tbsp).long_name, generated_list[food_name][GroceryList::UNIT_NAME_KEY], "expected unit name to match"
        else
          assert false, "food #{food_name} was not expected in the list"
      end
    end
  end
end
