class GroceryList < ActiveRecord::Base
  has_and_belongs_to_many :recipes
  has_many :grocery_list_foods, dependent: :destroy
  has_many :foods, :through => :grocery_list_foods

  accepts_nested_attributes_for :grocery_list_foods, allow_destroy: true

  validates :name, :presence => true
  validates_uniqueness_of :name

  attr_accessible :name
  attr_accessible :grocery_list_foods_attributes
end
