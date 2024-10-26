# frozen_string_literal: true

class ProfilePicture < ApplicationRecord
  AVATAR_SIZE = 125

  belongs_to :user
  belongs_to :source_media_asset, class_name: "MediaAsset" # the media asset the picture was cropped from
  belongs_to :avatar_media_asset, class_name: "MediaAsset" # the actual media asset itself

  # XXX Won't trigger before :crop_image which will cause an error
  validates :width, comparison: { greater_than: 0 }
  validates :height, comparison: { greater_than: 0 }

  delegate :post, to: :source_media_asset

  after_save :delete_old_profile_pictures

  deletable

  def self.search(params, current_user)
    q = search_attributes(params, [:id, :created_at, :updated_at, :user, :source_media_asset, :avatar_media_asset, :is_deleted], current_user: current_user)

    if params[:is_deleted].to_s.truthy?
      q = q.deleted
    else
      q = q.undeleted
    end

    q.apply_default_order(params)
  end

  def crop_image!
    if source_media_asset.role == "avatar"
      self.avatar_media_asset = source_media_asset
      return
    end

    source_media_asset.variant(:original).open_file! do |file|
      cropped_file = file.crop!(left, top, width, height)
      MediaAsset.upload!(cropped_file, role: "avatar") do |asset|
        self.avatar_media_asset = asset
      end
    end
  end

  def delete!(deleter = CurrentUser.user)
    transaction do
      if deleter != user
        ModAction.log("deleted the profile picture of user ##{user.id}", :profile_picture_delete, subject: user, user: deleter)
        Dmail.create_automated(to: user, title: "Your profile picture has been removed", body: <<~EOS)
          Your profile picture has been removed by @#{deleter.name}.

          Please remember to adhere to the profile pictures rules.
          * You must not use explicit content in profile pictures.
          * You must not use the same profile picture as a moderator or admin.
        EOS
      end

      update!(is_deleted: true)
    end
  end

  def delete_old_profile_pictures
    ProfilePicture.where(user_id: user_id).where.not(id: self.id).update_all(is_deleted: true)
  end
end
