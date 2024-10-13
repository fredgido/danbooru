# frozen_string_literal: true

class ProfilePicturesController < ApplicationController
  respond_to :html, :json, :xml, :js

  rate_limit :create, rate: 1.0/1.hour, burst: 3
  rate_limit :update, rate: 1.0/1.hour, burst: 3

  def index
    @profile_pictures = authorize ProfilePicture.includes(:user, :avatar_media_asset).paginated_search(params)
    respond_with(@profile_pictures)
  end

  def show
    @profile_picture = authorize ProfilePicture.find(params[:id])
    respond_with(@profile_picture)
  end

  def new
    @profile_picture = authorize ProfilePicture.new(user_id: CurrentUser.id, **permitted_attributes(ProfilePicture))
    raise ActiveRecord::RecordNotFound if @profile_picture.source_media_asset.nil?

    respond_with(@profile_picture)
  end

  def create
    if params[:media_asset_id].present?
      @media_asset = MediaAsset.find(params[:media_asset_id])
      if @media_asset.role == "avatar"
        @profile_picture = authorize ProfilePicture.find_by(avatar_media_asset_id: @media_asset.id).dup
        @profile_picture.user_id = CurrentUser.user.id
        @profile_picture.save!
      else
        flash[:notice] = "Invalid media asset type"
      end
    else
      if params.dig(:profile_picture, :width) == "0" || params.dig(:profile_picture, :height) == "0"
        flash[:notice] = "Invalid dimensions for avatar"
        return respond_with(@profile_picture, location: profile_pictures_path)
      end

      @profile_picture = authorize ProfilePicture.new(user_id: CurrentUser.id, **permitted_attributes(ProfilePicture))
      if @profile_picture.save
        flash[:notice] = "Avatar was set"
      else
        flash[:notice] = @profile_picture.errors.full_messages.join("; ")
      end
    end
    respond_with(@profile_picture, location: Routes.profile_path)
  end

  def edit
    @profile_picture = authorize ProfilePicture.find(params[:id])
    respond_with(@profile_picture, template: "profile_pictures/new")
  end

  def update
    @profile_picture = authorize ProfilePicture.find(params[:id])
    if @profile_picture.update(permitted_attributes(@profile_picture))
      flash[:notice] = "Avatar was updated"
    else
      flash[:notice] = @profile_picture.errors.full_messages.join("; ")
    end
    respond_with(@profile_picture, location: Routes.profile_path)
  end

  def destroy
    @profile_picture = authorize ProfilePicture.find(params[:id])
    @profile_picture.destroy!
    respond_with(@profile_picture)
  end
end
