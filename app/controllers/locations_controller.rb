class LocationsController < ApplicationController
  # before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_location, only: [:show, :update, :destroy]

  def index
    rawLocation = Location.all.order(id: "desc").includes(:ratings).with_attached_image
    @locations = rawLocation.map do |l|
      location = l.as_json
      location = location.merge({ratings: l.ratings.average(:stars).to_i})
      if l.image.attached?
        location = location.merge({image: l.image.service_url})
      end
      location
    end
    render json: @locations, status: 200
  end

  def show
    location = @location.as_json
    location = location.merge({ratings: @location.ratings.average(:stars).to_i})
    if @location.image.attached?
      location = location.merge({image: @location.image.service_url})
    end
    rawComment = Comment.includes(:user).where(location_id: @location.id)
    if rawComment.length==0 
      comments = [0]
    else 
      comments = rawComment.map do |c|
        comment = c.as_json
        comment = comment.merge({username: c.user.username})
      end
    end
    render json: {location: location, comments: comments}, status: 200
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
