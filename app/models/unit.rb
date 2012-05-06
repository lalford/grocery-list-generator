class Unit < ActiveRecord::Base
  has_many :ingredients

  validates :short_name, :presence => true
  validates_uniqueness_of :short_name
end
