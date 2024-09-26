# frozen_string_literal: true

class ProfilePicture < ApplicationRecord
  AVATAR_SIZE = 125

  belongs_to :user
  belongs_to :source_media_asset, class_name: "MediaAsset" # the media asset the picture was cropped from
  belongs_to :avatar_media_asset, class_name: "MediaAsset" # the actual media asset itself

  before_validation :crop_image

  # XXX Won't trigger before :crop_image which will cause an error
  validates :width, comparison: { greater_than: 0 }
  validates :height, comparison: { greater_than: 0 }

  def self.search(params, current_user)
    q = search_attributes(params, [:id, :created_at, :updated_at, :user, :source_media_asset, :avatar_media_asset], current_user: current_user)
    q.apply_default_order(params)
  end

  def post
    source_media_asset.post
  end

  def crop_image
    return if source_media_asset.role == "avatar"

    source_media_asset.variant(:original).open_file! do |file|
      cropped_file = file.crop!(left, top, width, height)
      MediaAsset.upload!(cropped_file, role: "avatar") do |asset|
        self.avatar_media_asset = asset
      end
    end
  end
end
