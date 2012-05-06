class RequireUnitsShortName < ActiveRecord::Migration
  def up
    change_column :units, :short_name, :string, :null => false
  end

  def down
    change_column :units, :short_name, :string, :null => true
  end
end
