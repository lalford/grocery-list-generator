class Recipe < ActiveRecord::Base
  has_many :ingredients, dependent: :destroy
  has_many :foods, :through => :ingredients

  accepts_nested_attributes_for :ingredients, allow_destroy: true, :reject_if => proc { |attributes| attributes['food_id'].blank? }

  validates :name, :presence => true
  validates_uniqueness_of :name
  validates_numericality_of :servings, :only_integer => true

  attr_accessible :name
  attr_accessible :servings
  attr_accessible :directions
  attr_accessible :ingredients_attributes

  def autocomplete_display
    "#{self.name}"
  end

  def self.search(query)
    if query
      find(:all, :conditions => ['name LIKE ?', "#{query}%"], :order => 'name')
    else
      find(:all, :order => 'name')
    end
  end
end
