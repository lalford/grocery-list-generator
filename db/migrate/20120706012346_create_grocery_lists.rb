class CreateGroceryLists < ActiveRecord::Migration
  def change
    create_table :grocery_lists do |t|
      t.column "name", :string, :null => false
      t.timestamps
    end

    create_table :grocery_lists_recipes, :id => false do |t|
      t.column "grocery_list_id", :integer, :null => false
      t.column "recipe_id", :integer, :null => false
      t.timestamps
    end

    create_table :grocery_lists_foods do |t|
      t.column "grocery_list_id", :integer, :null => false
      t.column "food_id", :integer, :null => false
      t.column "quantity", :float
      t.column "unit_id", :integer
      t.timestamps
    end
  end
end
