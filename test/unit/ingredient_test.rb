require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  test "should add plums to stuffed salmon" do
    ingredient = Ingredient.new { |i|
      i.food = foods(:plum)
      i.recipe = recipes(:stuffed_salmon)
      i.quantity = 2.0
    }
    assert ingredient.save, "should have assigned plums to the stuffed salmon recipe, even if it is a bad idea"
    assert ingredient.update_attributes({:quantity => 2.1, :unit_name => 'lbs'}), "should have added a quantity and unit to the new ingredient"
  end

  test "should fail to save with a non-numeric quantity" do
    ingredient = Ingredient.new { |i|
      i.food = foods(:plum)
      i.recipe = recipes(:stuffed_salmon)
      i.quantity = "five"
    }
    assert !ingredient.save, "should not have saved an ingredient with non-numeric quantity"
  end

  test "should fail to save without a quantity for the ingredient" do
    ingredient = Ingredient.new { |i|
      i.food = foods(:plum)
      i.recipe = recipes(:stuffed_salmon)
    }
    assert !ingredient.save, "should not have saved an ingredient without a quantity"
  end
end
