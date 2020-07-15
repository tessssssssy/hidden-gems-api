class LocationsController < ApplicationController
#     before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_location, only: [:show, :update, :destroy]

  def index
    @locations = Location.all.order(id: "desc")
    render json: @locations
  end

  def show
    render json: @location
  end

  def create
    location = current_user.locations.create(location_params)
    render json: location, status: 200
  end

  def update
    @location.update(location_params)
    render json: "location updated", status: 200
  end

  def destroy
    @location.destroy
    render json: "location deleted", status: 200
  end

  private

  def location_params
    params.require(:location).permit(:name, :description, :tagline, :address, :latitude, :longitude)
  end

  def set_location
    @location = location.find(params[:id])
  end
end
