class DropLabels < ActiveRecord::Migration
  def up
    drop_table :labels
  end

  def down
  end
end
