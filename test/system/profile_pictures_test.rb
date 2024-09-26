require "application_system_test_case"

class ProfilePicturesTest < ApplicationSystemTestCase
  setup do
    @profile_picture = profile_pictures(:one)
  end

  test "visiting the index" do
    visit profile_pictures_url
    assert_selector "h1", text: "Profile pictures"
  end

  test "should create profile picture" do
    visit profile_pictures_url
    click_on "New profile picture"

    click_on "Create Profile picture"

    assert_text "Profile picture was successfully created"
    click_on "Back"
  end

  test "should update Profile picture" do
    visit profile_picture_url(@profile_picture)
    click_on "Edit this profile picture", match: :first

    click_on "Update Profile picture"

    assert_text "Profile picture was successfully updated"
    click_on "Back"
  end

  test "should destroy Profile picture" do
    visit profile_picture_url(@profile_picture)
    click_on "Destroy this profile picture", match: :first

    assert_text "Profile picture was successfully destroyed"
  end
end
