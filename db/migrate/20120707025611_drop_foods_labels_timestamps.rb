class DropFoodsLabelsTimestamps < ActiveRecord::Migration
  def up
    remove_column :foods_labels, :created_at, :updated_at
  end

  def down
  end
end
