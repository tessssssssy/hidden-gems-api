class LocationsController < ApplicationController
  # before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_location, only: [:show, :update, :destroy]

  def index
    @locations = Location.all.order(id: "desc")
    render json: @locations, status: 200
  end

  def show
    raw = Comment.includes(:user).where(location_id: @location.id)
    comments = raw.map do |c|
      {id: c.id, body: c.body, user: c.user.username, created_at: c.created_at, thread_id: c.thread_id}
    end
    render json: {location: @location, comments: comments}
  end

  def create
    location = Location.new(location_params)
    if location.save
      render json: location, status: :created
    else
      render json: { errors: location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      render json: "location updated", status: :no_content
    else
      render json: { errors: @location.errors.full_messages },
             status: :unprocessable_entity
    end
  end  
  def destroy
    @location.destroy
    render json: "location deleted", status: :no_content
  end

  private

  def location_params
    params.require(:location).permit(:name, :description, :tagline, :address, :longitude, :latitude)
  end

  def set_location
    @location = Location.find(params[:id])
  end
end
