require 'test_helper'

class FoodTest < ActiveSupport::TestCase
  test "should create a new food" do
    food = Food.new
    food.name= "junk food"
    assert food.save, "failed to save #{food.name}"
  end

  test "should fail to create a food with an existing name" do
    food = Food.new
    food.name= foods(:salmon).name
    assert !food.save, "saved food with existing name"
  end

  test "should fail to create a food with no name" do
    food = Food.new
    assert !food.save, "saved food without a name"
  end

  test "should find salmon to be a meat and a protein as well as part of the stuffed salmon recipe" do
    salmon = foods(:salmon)
    assert salmon.valid?
    labels = salmon.labels
    assert_equal labels.size, 2, "expected 2 labels for meat and protein"
    labels.each { |label|
      assert (label.name.casecmp("meat") or label.name.casecmp("protein")), "expected labels of meat and protein"
    }
    recipes = salmon.recipes
    assert_equal recipes.size, 1, "expected 1 recipe for stuffed salmon"
    assert recipes[0].name.casecmp("stuffed salmon"), "expected stuffed salmon recipe"
  end
end
