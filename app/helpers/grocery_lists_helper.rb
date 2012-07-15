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

  # if the generator could not convert the units, the quantity and unit sums are returned added together
  def self.construct_formula_display_for_unsupported_conversion(quantity_sum, unit_sum)
    quantities = quantity_sum.split "+"
    units = unit_sum.split "+"
    formula = ""
    quantities.zip(units).each do |q, u|
      formula = formula + " + " unless formula.empty?
      formula = formula + "#{q} #{u}"
    end
    formula
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
