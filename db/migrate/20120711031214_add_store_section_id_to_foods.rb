class AddStoreSectionIdToFoods < ActiveRecord::Migration
  def change
    add_column :foods, :store_location_id, :integer
  end
end
