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
end
