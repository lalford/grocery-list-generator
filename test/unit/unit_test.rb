require 'test_helper'

class UnitTest < ActiveSupport::TestCase
  test "should create a unit with short and long name" do
    unit = Unit.new
    unit.short_name = "ml"
    unit.long_name = "milliliters"
    assert unit.save, "failed to save #{unit.short_name}"
   end

  test "should create a unit with short and no long name" do
    unit = Unit.new
    unit.short_name = "cup"
    assert unit.save, "failed to save #{unit.short_name}"
   end

  test "should fail to create a unit with no short name" do
    unit = Unit.new
    assert !unit.save, "should not have saved unit with no short name"
   end

  test "should fail to create a unit with an existing short name" do
    unit = Unit.new
    unit.short_name = "oz"
    assert !unit.save, "should not have saved unit with existing short name"
  end

  test "should fail to create a unit with a short name longer than 5 characters" do
    unit = Unit.new
    unit.short_name = "abcdef"
    assert !unit.save, "should not have saved unit with a short name over 5 characters"
  end

  test "should fail to create a unit with a long name under 5 characters" do
    unit = Unit.new
    unit.short_name = "abc"
    unit.long_name = "abc"
    assert !unit.save, "should not have saved unit with a long name under 5 characters"
  end
end
