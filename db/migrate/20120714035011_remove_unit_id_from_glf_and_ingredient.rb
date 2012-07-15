class RemoveUnitIdFromGlfAndIngredient < ActiveRecord::Migration
  def up
    remove_column :grocery_lists_foods, :unit_id
  end

  def down
  end
end
