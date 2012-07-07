class ForceNullableTimestampsOnGlr < ActiveRecord::Migration
  def up
    change_column :grocery_lists_recipes, :created_at, :datetime, :null => true
    change_column :grocery_lists_recipes, :updated_at, :datetime, :null => true
  end

  def down
  end
end
