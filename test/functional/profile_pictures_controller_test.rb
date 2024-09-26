require "test_helper"

class ProfilePicturesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @profile_picture = profile_pictures(:one)
  end

  test "should get index" do
    get profile_pictures_url
    assert_response :success
  end

  test "should get new" do
    get new_profile_picture_url
    assert_response :success
  end

  test "should create profile_picture" do
    assert_difference("ProfilePicture.count") do
      post profile_pictures_url, params: { profile_picture: {  } }
    end

    assert_redirected_to profile_picture_url(ProfilePicture.last)
  end

  test "should show profile_picture" do
    get profile_picture_url(@profile_picture)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_picture_url(@profile_picture)
    assert_response :success
  end

  test "should update profile_picture" do
    patch profile_picture_url(@profile_picture), params: { profile_picture: {  } }
    assert_redirected_to profile_picture_url(@profile_picture)
  end

  test "should destroy profile_picture" do
    assert_difference("ProfilePicture.count", -1) do
      delete profile_picture_url(@profile_picture)
    end

    assert_redirected_to profile_pictures_url
  end
end
