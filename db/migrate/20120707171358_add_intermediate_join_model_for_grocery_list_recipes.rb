class AddIntermediateJoinModelForGroceryListRecipes < ActiveRecord::Migration
  def up
    drop_table :grocery_lists_recipes

    create_table :grocery_lists_recipes do |t|
      t.column "grocery_list_id", :integer, :null => false
      t.column "recipe_id", :integer, :null => false
      t.column "quantity", :float
      t.timestamps
    end
  end

  def down
  end
end
