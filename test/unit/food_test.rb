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

  test "should find salmon" do
    results = Food.search "salmon"
    assert_not_nil results
    assert_equal 1, results.length, "expected only 1 result"
    assert_equal foods(:salmon).name, results[0].name, "expected to find salmon"
  end

  test "should find nothing" do
    nothing = Food.search "asdflkjqlwkerjlkj asdf"
    assert_equal [], nothing, "expected an empty set"
  end

  test "should find and alphabetize all foods starting in s" do
    results = Food.search "s"
    assert_not_nil results
    assert_equal 3, results.length, "expected 3 items starting in 's'"
    assert_equal foods(:salmon).name, results[0].name, "expected to find salmon"
    assert_equal foods(:spinach).name, results[1].name, "expected to find spinach"
    assert_equal foods(:sundried_tomato).name, results[2].name, "expected to find sundried tomato"
  end

  test "should provide the food name for the autocomplete display" do
    food = foods(:spinach)
    assert_equal foods(:spinach).name, food.autocomplete_display, "expected method to provide the food name"
  end

  test "should find salmon in the seafood section" do
    salmon = Food.find foods(:salmon).id
    assert_not_nil salmon, "should have found salmon"
    assert_equal store_sections(:seafood), salmon.store_section, "should have found salmon in the seafood section"
  end

  test "should find the 2 items in the produce section" do
    produce = Food.find_all_by_store_section_id store_sections(:produce).id
    assert_not_nil produce, "should have found some produce"
    assert_equal 2, produce.count, "should have found 2 foods in the produce section"
  end
end
