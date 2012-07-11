class CreateStoreSections < ActiveRecord::Migration
  def change
    create_table :store_sections do |t|
      t.string :name

      t.timestamps
    end
  end
end
