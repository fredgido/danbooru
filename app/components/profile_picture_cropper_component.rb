# frozen_string_literal: true

# A component for cropping a media asset for use as an avatar.
class ProfilePictureCropperComponent < ApplicationComponent
  attr_reader :profile_picture, :current_user

  delegate :image_width, :image_height, :variant, :is_image?, :is_video?, :is_ugoira?, :is_flash?, to: :media_asset

  def initialize(profile_picture, current_user:)
    super
    @profile_picture = profile_picture
    @current_user = current_user
  end

  def media_asset
    profile_picture.source_media_asset
  end
end
