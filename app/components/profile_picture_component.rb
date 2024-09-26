# frozen_string_literal: true

# A component for render user avatars.
class ProfilePictureComponent < ApplicationComponent
  attr_reader :profile_picture, :current_user

  delegate :image_width, :image_height, :variant, :is_image?, :is_video?, :is_ugoira?, :is_flash?, to: :media_asset

  def initialize(profile_picture)
    super
    @profile_picture = profile_picture
  end

  def media_asset
    profile_picture.avatar_media_asset
  end
end
