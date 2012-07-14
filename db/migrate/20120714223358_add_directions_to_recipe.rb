class AddDirectionsToRecipe < ActiveRecord::Migration
  def change
    add_column :recipes, :directions, :text, :limit => 500
  end
end
