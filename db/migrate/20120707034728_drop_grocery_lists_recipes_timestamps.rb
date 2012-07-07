class DropGroceryListsRecipesTimestamps < ActiveRecord::Migration
  def up
    remove_column :grocery_lists_recipes, :created_at, :updated_at
  end

  def down
  end
end
