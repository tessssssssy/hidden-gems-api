class LikesController < ApplicationController
  before_action :authenticate_user, only: [:index, :show, :create, :destroy]
  def create
    existingRating = Rating.where(user_id: current_user.id, location_id: ratings_params[:location_id])
    if existingRating.length === 0
      rating = current_user.ratings.create(ratings_params)
      if rating.errors.any?
        render json: { errors: ratings.errors.full_messages }, status: :unprocessable_entity
      else
        render status: :created
      end
    else
      render status: :no_content
    end
  end
end