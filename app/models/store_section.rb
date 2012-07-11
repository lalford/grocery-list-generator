class StoreSection < ActiveRecord::Base
  has_many :foods

  attr_accessible :name

  validates :name, :presence => true
  validates_uniqueness_of :name
end
