class Food < ActiveRecord::Base
  has_many :ingredients, dependent: :destroy
  has_many :recipes, :through => :ingredients
  belongs_to :store_section

  attr_accessible :name
  attr_accessible :description
  attr_accessible :store_section_id

  validates :name, :presence => true
  validates_uniqueness_of :name

  def autocomplete_display
    "#{self.name}"
  end

  def self.search(query)
    if query
      find(:all, :conditions => ['name LIKE ?', "#{query}%"], :order => "LOWER(name)")
    else
      find(:all, :order => 'name')
    end
  end
end
