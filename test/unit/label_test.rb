require 'test_helper'

class LabelTest < ActiveSupport::TestCase
  test "should create a new label" do
    label = Label.new
    label.name= "junk label"
    assert label.save, "failed to save #{label.name}"
  end

  test "should fail to create a label with an existing name" do
    label = Label.new
    label.name= labels(:meat).name
    assert !label.save, "saved label with existing name"
  end

  test "should fail to create a label with no name" do
    label = Label.new
    assert !label.save, "saved label without a name"
  end

  test "should find fruit to be a label for sundried tomato and plum" do
    fruit = labels(:fruit)
    assert fruit.valid?
    foods = fruit.foods
    assert_equal foods.size, 2, "expected 2 fruits, sundried tomato and plum"
    foods.each { |food|
      assert (food.name.casecmp("sundried tomato") or food.name.casecmp("plum")), "expected fruits of sundried tomato and plum"
    }
  end
end
