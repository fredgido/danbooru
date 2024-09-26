class ProfilePicturePolicy < ApplicationPolicy
  def show?
    record.post.visible?(user)
  end

  def create?
    record.source_media_asset&.post.blank? || record.source_media_asset&.post&.visible?(User.anonymous)
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user || user.is_admin?
  end

  def permitted_attributes
    %i[source_media_asset_id left top width height]
  end
end
