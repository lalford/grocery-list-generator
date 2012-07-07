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

  test "should create a new grocery list with the foods plums and pine nuts and the stuffed salmon recipe" do
    grocery_list = GroceryList.new { |l|
      l.name = "a test list"
    }
    grocery_list_food1 = GroceryListFood.new { |glf|
      glf.grocery_list = grocery_lists(:l1)
      glf.food = foods(:plum)
      glf.quantity = 2
      glf.unit = units(:bag)
    }
    grocery_list.grocery_list_foods = [grocery_list_food1]
    grocery_list.foods = [foods(:pine_nuts)]
    grocery_list.recipes = [recipes(:stuffed_salmon)]
    assert grocery_list.save, "failed to save grocery list #{grocery_list.name}"
  end
end
