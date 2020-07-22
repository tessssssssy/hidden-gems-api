class LocationsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_location, only: [:show, :update, :destroy]

  def index
    rawLocation = Location.all.order(id: "desc").includes(:ratings)
    @locations = rawLocation.map do |l|
      {id: l.id, name: l.name, description: l.description, tagline: l.tagline, address: l.address, longitude: l.longitude, latitude: l.latitude, ratings: l.ratings.average(:stars).to_i}
    end
    render json: @locations, status: 200
  end

  def show
    location = {id: @location.id, name: @location.name, description: @location.description, tagline: @location.tagline, address: @location.address, longitude: @location.longitude, latitude: @location.latitude, ratings: @location.ratings.average(:stars).to_i}
    rawComment = Comment.includes(:user).where(location_id: @location.id)
    if rawComment.length==0 
      comments = [0]
    else 
      comments = rawComment.map do |c|
        {id: c.id, body: c.body, user: c.user.username, created_at: c.created_at, thread_id: c.thread_id}
      end
    end
    render json: {location: location, comments: comments}, status: 200
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
      render json: "location updated", status: :ok
    else
      render json: { errors: @location.errors.full_messages },
             status: :unprocessable_entity
    end
  end  
  def destroy
    @location.destroy
    render json: "location deleted", status: :ok
  end

  private

  def location_params
    params.require(:location).permit(:name, :description, :tagline, :address, :longitude, :latitude)
  end

  def set_location
    @location = Location.find(params[:id])
  end
end
