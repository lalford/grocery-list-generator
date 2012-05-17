class Recipe < ActiveRecord::Base
  has_many :ingredients, dependent: :destroy
  has_many :foods, :through => :ingredients

  accepts_nested_attributes_for :ingredients, allow_destroy: true

  validates :name, :presence => true
  validates_uniqueness_of :name

  # builds a list of all foods as selected/unselected ingredients
  def build_available_ingredient_list
    list = [].tap do |ingredient_list|
      Food.all.each do |food|
        if ingredient = ingredients.find { |ing| ing.food_id == food.id }
          #ingredient_list << ingredient.tap { |ing| ing.selected ||= true }
        else
          ingredient_list << Ingredient.new(food: food)
        end
      end
    end
    list.sort! { |i1,i2| i1.food.name <=> i2.food.name }
  end

end
