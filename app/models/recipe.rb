class Recipe < ActiveRecord::Base
  has_many :ingredients, dependent: :destroy
  has_many :foods, :through => :ingredients

  accepts_nested_attributes_for :ingredients, allow_destroy: true

  validates :name, :presence => true
  validates_uniqueness_of :name

  attr_accessible :name
  attr_accessible :ingredients_attributes

  def autocomplete_display
    "#{self.name}"
  end
end
