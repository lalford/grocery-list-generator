require 'ruby-units'

module GroceryListsHelper
  def self.build_unit_select_list
    unit_definitions = Unit.definitions
    unit_keys = unit_definitions.keys.sort { |unit1, unit2|
      unit_display_name(unit_definitions[unit1]) <=> unit_display_name(unit_definitions[unit2])
    }
    unit_select_list = []
    unit_keys.each do |unit_key|
      unit = unit_definitions[unit_key]
      unit_select_list << [unit.display_name, unit_display_name(unit)]
    end
    unit_select_list
  end

  def self.unit_display_name(unit)
    (unit.aliases and (unit.aliases.count > 1)) ? unit.aliases[1] : unit.display_name
  end
end
