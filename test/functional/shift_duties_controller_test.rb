require 'test_helper'

class ShiftDutiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shift_duties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shift_duty" do
    assert_difference('ShiftDuty.count') do
      post :create, :shift_duty => { }
    end

    assert_redirected_to shift_duty_path(assigns(:shift_duty))
  end

  test "should show shift_duty" do
    get :show, :id => shift_duties(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => shift_duties(:one).to_param
    assert_response :success
  end

  test "should update shift_duty" do
    put :update, :id => shift_duties(:one).to_param, :shift_duty => { }
    assert_redirected_to shift_duty_path(assigns(:shift_duty))
  end

  test "should destroy shift_duty" do
    assert_difference('ShiftDuty.count', -1) do
      delete :destroy, :id => shift_duties(:one).to_param
    end

    assert_redirected_to shift_duties_path
  end
end
