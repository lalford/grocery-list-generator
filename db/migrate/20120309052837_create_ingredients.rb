class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.column "food_id", :integer, :null => false
      t.column "recipe_id", :integer, :null => false
      t.column "quantity", :float

      t.timestamps
    end
  end
end
