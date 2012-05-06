require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test "should create a new recipe" do
    recipe = Recipe.new
    recipe.name= "junk recipe"
    assert recipe.save, "failed to save #{recipe.name}"
  end

  test "should fail to create a recipe with an existing name" do
    recipe = Recipe.new
    recipe.name= recipes(:stuffed_salmon).name
    assert !recipe.save, "should not save recipe with existing name"
  end

  test "should fail to create a recipe with no name" do
    recipe = Recipe.new
    assert !recipe.save, "should not save recipe without a name"
  end

  test "should create a new recipe with plums and pesto" do
    recipe = Recipe.new { |r|
      r.name= "horrible recipe"
    }
    ingredient1 = Ingredient.new { |i|
      i.food = foods(:plum)
      i.recipe = recipe
      i.quantity = 2
      i.unit = units(:bag)
    }
    ingredient2 = Ingredient.new { |i|
      i.food = foods(:pesto)
      i.recipe = recipe
      i.quantity = 0.23
      i.unit = units(:tbsp)
    }
    recipe.ingredients= [ingredient1, ingredient2]
    assert recipe.save, "failed to save recipe #{recipe.name} with ingredients #{recipe.ingredients.to_s}"
  end

  test "should build a list of foods as selected and unselected ingredients for the stuffed salmon recipe" do
    recipe = recipes :stuffed_salmon
    assert_not_nil recipe, "failed to find stuffed salmon recipe"
    ingredients = recipe.build_ingredient_list
    assert_not_nil ingredients
    assert_equal 6, ingredients.length, "expected 6 ingredients, found #{ingredients.length}"
    ingredients.each do |ingredient|
      assert_not_nil ingredient.food, "expected ingredient to be associated with a food"
      if ingredient.recipe == nil
        assert_nil ingredient.quantity, "expected no quantity for a food not associated with the recipe"
        assert_nil ingredient.unit, "expected no unit for a food not associated with the recipe"
        assert (ingredient.selected == nil or ingredient.selected == false), "expected a food not currently associated with a recipe to not have the selected flag set"
      else
        assert (ingredient.quantity > 0), "expected #{ingredient.food.name} to have a quantity"
        assert_not_nil ingredient.unit, "expected #{ingredient.food.name} to have a unit"
        assert (ingredient.selected == true), "expected #{ingredient.food.name} to be selected"
      end
    end
  end
end
