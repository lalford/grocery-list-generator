class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :short_name
      t.string :long_name

      t.timestamps
    end

    add_column :ingredients, :unit_id, :integer
    remove_column :ingredients, :unit
  end
end
