class ForceNullableTimestampsOnGlf < ActiveRecord::Migration
  def up
    change_column :grocery_lists_foods, :created_at, :datetime, :null => true
    change_column :grocery_lists_foods, :updated_at, :datetime, :null => true
  end

  def down
  end
end
