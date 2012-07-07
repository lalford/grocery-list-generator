class DropFoodLabelsTable < ActiveRecord::Migration
  def up
    drop_table :food_labels
  end

  def down
  end
end
