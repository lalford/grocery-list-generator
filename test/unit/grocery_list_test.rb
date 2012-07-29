require 'test_helper'

class GroceryListTest < ActiveSupport::TestCase
  test "should create a new grocery list" do
    grocery_list = GroceryList.new
    grocery_list.name = "fake list"
    assert grocery_list.save, "failed to save #{grocery_list.name}. #{grocery_list.errors.to_hash}"
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
    }
    grocery_list_recipe1 = GroceryListRecipe.new { |glr|
      glr.grocery_list = grocery_lists(:l1)
      glr.recipe = recipes(:stuffed_salmon)
      glr.quantity = 3
    }
    grocery_list.grocery_list_foods = [grocery_list_food1]
    grocery_list.grocery_list_recipes = [grocery_list_recipe1]
    assert grocery_list.save, "failed to save grocery list #{grocery_list.name}. #{grocery_list.errors.to_hash}"
  end

  # Current example:
  #
  # l1:
  #   recipes:
  #     stuffed_salmon (2 servings):
  #       salmon, 2, lbs
  #       spinach, 16, oz
  #       sundried tomato, .5, tbs
  #       pine nuts, 10, oz
  #       pesto, 8, tbs
  #   foods:
  #     pine nuts, 10, oz
  #     plum, 3, nil
  #     spinach, 1, lbs
  #
  # generated_list:
  #   no section
  #     pesto, 8, tbs
  #     pine nuts, 20, oz
  #     sundried tomato, .5, tbs
  #   produce
  #     plum, 3, blank
  #     spinach, 32, oz
  #   seafood
  #     salmon, 2, lbs
  #
  test "should generate the grocery list hash from fixture data" do
    grocery_list = grocery_lists(:l1)
    generated_list = grocery_list.generate
    assert_not_nil generated_list, "should have built a grocery list"
    assert_equal 3, generated_list.keys.count, "should have had 3 store sections in this list"
    puts "whole generated list:\n#{generated_list}"
    validate_generated_list generated_list
  end

  def validate_generated_list(generated_list)
    assert_not_nil generated_list
    generated_list.keys.sort.each do |store_section_name|
      puts "store section key = #{store_section_name}"
      section_food_list = generated_list[store_section_name]
      case store_section_name
        when GroceryList::NO_SECTION_KEY
          assert_equal 3, section_food_list.keys.count, "should have had 3 foods without a store section defined"
        when store_sections(:produce).name
          assert_equal 2, section_food_list.keys.count, "should have had 2 foods in the produce section"
        when store_sections(:seafood).name
          assert_equal 1, section_food_list.keys.count, "should have had 1 food in the seafood section"
        else
          assert false, "section #{store_section_name} was not expected in the list"
      end
      validate_section_food_list section_food_list
    end
  end

  def validate_section_food_list(section_food_list)
    section_food_list.keys.each do |food_name|
      puts "food key = #{food_name}"
      actual_quantity = section_food_list[food_name][GroceryList::QUANTITY_KEY].to_f
      actual_unit_name = section_food_list[food_name][GroceryList::UNIT_NAME_KEY]
      expected_unit_name = Unit("#{section_food_list[food_name][GroceryList::UNIT_NAME_KEY]}").to_s.split[1] if section_food_list[food_name][GroceryList::UNIT_NAME_KEY]
      case food_name
        when foods(:pesto).name
          assert_equal 8, actual_quantity, "expected quantities to match"
          assert_equal expected_unit_name, actual_unit_name, "expected unit name to match"
        when foods(:pine_nuts).name
          assert_equal 20, actual_quantity, "expected quantities to match"
          assert_equal expected_unit_name, actual_unit_name, "expected unit name to match"
        when foods(:plum).name
          assert_equal 3, actual_quantity, "expected quantities to match"
          assert_blank expected_unit_name, "expected no unit"
        when foods(:salmon).name
          assert_equal 2, actual_quantity, "expected quantities to match"
          assert_equal expected_unit_name, actual_unit_name, "expected unit name to match"
        when foods(:spinach).name
          assert_equal 32, actual_quantity, "expected quantities to match"
          assert_equal expected_unit_name, actual_unit_name, "expected unit name to match"
        when foods(:sundried_tomato).name
          assert_equal 0.5, actual_quantity, "expected quantities to match"
          assert_equal expected_unit_name, actual_unit_name, "expected unit name to match"
        else
          assert false, "food #{food_name} was not expected in the list"
      end
    end
  end
end
