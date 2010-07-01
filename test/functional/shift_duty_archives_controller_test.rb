require 'test_helper'

class ShiftDutyArchivesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shift_duty_archives)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shift_duty_archive" do
    assert_difference('ShiftDutyArchive.count') do
      post :create, :shift_duty_archive => { }
    end

    assert_redirected_to shift_duty_archive_path(assigns(:shift_duty_archive))
  end

  test "should show shift_duty_archive" do
    get :show, :id => shift_duty_archives(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => shift_duty_archives(:one).to_param
    assert_response :success
  end

  test "should update shift_duty_archive" do
    put :update, :id => shift_duty_archives(:one).to_param, :shift_duty_archive => { }
    assert_redirected_to shift_duty_archive_path(assigns(:shift_duty_archive))
  end

  test "should destroy shift_duty_archive" do
    assert_difference('ShiftDutyArchive.count', -1) do
      delete :destroy, :id => shift_duty_archives(:one).to_param
    end

    assert_redirected_to shift_duty_archives_path
  end
end
