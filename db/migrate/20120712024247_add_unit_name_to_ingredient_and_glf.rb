class AddUnitNameToIngredientAndGlf < ActiveRecord::Migration
  def change
    add_column :ingredients, :unit_name, :string
    add_column :grocery_lists_foods, :unit_name, :string
  end
end
