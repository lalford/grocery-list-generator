require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  test "should add plums to stuffed salmon" do
    ingredient = Ingredient.new { |i|
      i.food = foods(:plum)
      i.recipe = recipes(:stuffed_salmon)
      i.quantity = 5
    }
    assert ingredient.save, "should have assigned plums to the stuffed salmon recipe, even if it is a bad idea"
  end

  test "should fail to save without a quantity" do
    ingredient = Ingredient.new { |i|
      i.food = foods(:plum)
      i.recipe = recipes(:stuffed_salmon)
    }
    assert !ingredient.save, "should not have saved an ingredient with no quantity"
  end
end
