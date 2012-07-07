class AddFoodLabelJoinTable < ActiveRecord::Migration
  def up
    create_table :foods_labels do |t|
      t.integer :food_id
      t.integer :label_id
      t.timestamps
    end 
  end

  def down
    drop_table :foods_labels
  end
end
