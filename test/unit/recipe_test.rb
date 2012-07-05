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
end
