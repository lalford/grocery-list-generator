class RemoveFoodLabelPk < ActiveRecord::Migration
  def up
    remove_column :foods_labels, :id
  end

  def down
  end
end
