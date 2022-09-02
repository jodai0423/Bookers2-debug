class RelationshipsController < ApplicationController

  def create
    user = User.find(params[:user_id])
    relationship = current_user.relationships.new(followed_id: user.id)
    relationship.save
    redirect_back fallback_location: root_path
  end

  def destroy
    user = User.find(params[:user_id])
    relationship = current_user.reletionshps.find_by(followed: user.id)
    relationship.destroy
    redirect_back fallback_location: root_path
  end

  def followings
    user = User.find(params[:user_id])
    @user = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @user = user.followers
  end

end
