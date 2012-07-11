class FixColumnNameStupidity < ActiveRecord::Migration
  def up
    remove_column :foods, :store_location_id
    add_column :foods, :store_section_id, :integer
  end

  def down
  end
end
