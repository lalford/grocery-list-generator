require 'ruby-units'

module GroceryListsHelper
  def self.build_unit_select_list
    unit_definitions = Unit.definitions
    unit_keys = unit_definitions.keys.sort { |unit1, unit2|
      unit_definitions[unit1].display_name <=> unit_definitions[unit2].display_name
    }
    unit_select_list = []
    unit_keys.each do |unit_key|
      unit = unit_definitions[unit_key]
      unit_select_list << unit.display_name if ENABLED_UNIT_KEYS.include?(unit.name)
    end
    unit_select_list
  end

  private

  # strings match keys to the ruby-units definitions hash
  ENABLED_UNIT_KEYS = [
    '<quart>',
    '<pint>',
    '<cup>',
    '<fluid-ounce>',
    '<tablespoon>',
    '<teaspoon>',
    '<pound>',
    '<ounce>',
    '<gram>',
    '<milliliter>']

end
