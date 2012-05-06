class Label < ActiveRecord::Base
  has_and_belongs_to_many :foods

  validates :name, :presence => true
  validates_uniqueness_of :name
end
