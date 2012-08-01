class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  # helper to compute quantity from fraction for any controller wanting to support this entry format
  def compute_fractional_quantities(attributes_hash)
    fraction_pattern = "[[:space:]]*[0-9]+[[:space:]]*\/[[:space:]]*[0-9]+[[:space:]]*"
    attributes_hash.each do |key, attr|
      computed_quantity = attr[GroceryList::QUANTITY_KEY].match(/#{fraction_pattern}/) do |fraction|
        parts = fraction.string.split("/")
        numerator = parts[0].strip.to_f
        denominator = parts[1].strip.to_f
        numerator / denominator
      end
      attr[GroceryList::QUANTITY_KEY] = computed_quantity.nil? ? attr[GroceryList::QUANTITY_KEY] : computed_quantity
    end
  end
end
