class Unit < ActiveRecord::Base
  has_many :ingredients

  validates :short_name, :presence => true
  validates_uniqueness_of :short_name
  validates_length_of :short_name, :minimum => 1, :maximum => 5

  validates_length_of :long_name, :minimum => 5, :maximum => 255, :allow_blank => true, :allow_nil => true
end
