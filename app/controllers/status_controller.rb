class StatusController < ApplicationController
  before_action :authenticate_user

  def index
    render json: { message: 'logged in' }
  end

  def user
    likes = Like.where(user_id: current_user.id).pluck(:location_id)
    ratings = current_user.ratings
    render json: { user: current_user.username, likes: likes, ratings: ratings }
  end
end
