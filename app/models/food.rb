class Food < ActiveRecord::Base
  has_many :ingredients, dependent: :destroy
  has_many :recipes, :through => :ingredients
  has_and_belongs_to_many :labels

  validates :name, :presence => true
  validates_uniqueness_of :name

  def self.search(query)
    if query
      find(:all, :conditions => ['name LIKE ?', "#{query}%"], :order => 'name')
    else
      find(:all)
    end
  end
end
