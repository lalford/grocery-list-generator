require 'test_helper'

class FoodsControllerTest < ActionController::TestCase
  setup do
    @food = foods(:salmon)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:foods)
  end

  test "should find sundried tomato" do
    get :index, {:format => :json, 'substring' => 'dried tom'}
    assert_response :success
    assert_not_nil assigns(:foods)

    found_foods = JSON.parse response.body
    assert_not_nil found_foods
    assert_equal 1, found_foods.length
    assert_equal foods(:sundried_tomato).id, found_foods[0]['id']
    assert_equal foods(:sundried_tomato).name, found_foods[0]['name']
  end

  test "should find sundried tomato and pesto" do
    get :index, {:format => :json, 'substring' => 'to'}
    assert_response :success
    assert_not_nil assigns(:foods)

    found_foods = JSON.parse response.body
    assert_not_nil found_foods
    assert_equal 2, found_foods.length
    assert_equal foods(:pesto).id, found_foods[0]['id']
    assert_equal foods(:pesto).name, found_foods[0]['name']
    assert_equal foods(:sundried_tomato).id, found_foods[1]['id']
    assert_equal foods(:sundried_tomato).name, found_foods[1]['name']
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create food" do
    food = Food.new name: "a new food"
    assert_difference('Food.count') do
      post :create, food: food.attributes
    end

    assert_redirected_to food_path(assigns(:food))
  end

  test "should show food" do
    get :show, id: @food
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @food
    assert_response :success
  end

  test "should update food" do
    put :update, id: @food, food: @food.attributes
    assert_redirected_to food_path(assigns(:food))
  end

  test "should destroy food" do
    assert_difference('Food.count', -1) do
      delete :destroy, id: @food
    end

    assert_redirected_to foods_path
  end
end
