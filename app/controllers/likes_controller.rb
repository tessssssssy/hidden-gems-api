class LikesController < ApplicationController
  before_action :authenticate_user, only: [:index, :show, :create, :destroy]
  def index
    likes = Rating.where(user_id: current_user.id).pluck(:location_id)
    render json: { likes: likes }, status: :ok
  end

  def create
    like = current_user.likes.new(location_id: params[:location_id])
    if like.save
        render status: :created
    else
      render status: :no_content
    end
  end

  def destroy
    current_user.likes.find_by(location_id: params[:location_id]).destroy
    render json: 'like deleted', status: :ok

  end
end