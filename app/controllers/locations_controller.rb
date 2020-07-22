class LocationsController < ApplicationController
  # before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_location, only: [:show, :update, :destroy]

  def index
    @locations = Location.all.with_attached_image #order(id: "desc")
    render json: generate_image_urls(@locations) 
  end

  def show
    p @location.image.service_url
    p @location
    render json: @location
  end

  def create
    location = Location.new(location_params)
    if location.save
      if location_params[:image]
        render json: { location: location, image: url_for(location.image) }, status: :created
      else
        render json: { location: location, image: '' }, status: :created
      end
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
    params.require(:location).permit(:name, :description, :tagline, :address, :longitude, :latitude, :image)
  end

  def set_location
    @location = Location.find(params[:id])
  end

  def generate_image_urls(locations)
    locations.map do |location|
      if location.image.attached?
        location.attributes.merge(image: url_for(location.image))
      else
        location
      end
    end
  end
end
