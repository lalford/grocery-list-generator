class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :name

      t.timestamps
    end

    create_table "food_labels", :id => false do |t|
      t.column "food_id", :integer, :null => false
      t.column "label_id", :integer, :null => false
    end
  end
end
