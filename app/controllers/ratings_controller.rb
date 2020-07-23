class RatingsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  def create
  byebug
    rating = current_user.ratings.create(ratings_params)
    if rating.errors.any?
      render json: { errors: ratings.errors.full_messages }, status: :unprocessable_entity
    else
      render status: :created
    end
  end

  private

  def ratings_params
    params.require(:ratings).permit(:stars, :location_id)
  end
end