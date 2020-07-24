class LocationsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_location, only: [:show, :update, :destroy]

  def index
    rawLocation = Location.all.order(id: "desc").includes(:ratings, :user)
    @locations = rawLocation.map do |l|
      photos = Photo.where(location_id: l.id)
      photos = generate_image_urls(photos)
      location = l.as_json
      location = location.merge({photos: photos, ratings: l.ratings.average(:stars).to_i, numberOfRatings: l.ratings.count, username: l.user.username})
    end
    render json: @locations, status: 200
  end

  def show
    location = @location.as_json
    photos = Photo.where(location_id: @location.id)
    photos = generate_image_urls(photos)
    location = location.merge({photos: photos, ratings: @location.ratings.average(:stars).to_i, numberOfRatings: @location.ratings.count, username: @location.user.username})
    
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
    location = current_user.locations.new(location_params) #.merge(location_id: new_location.id) .merge(photo_params)
    if location.save
      photo = current_user.photos.create(location_id: location.id, image: params[:location][:image], main: true)
        render json: { location: location, image: url_for(photo.image) }, status: :created
    else
      render json: { errors: location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update  
    # location_attributes = location_params.to_hash
    photo = Photo.where(location_id: params[:id], main: true)
    image = params[:location][:image]
    if !image
      image = photo.image_attachment.blob
    end
    if @location.update(location_params) && photo.update(image: image)
      render json: { location: @location, image: url_for(photo.image) }, status: :ok
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

  def photo_params
    params.require(:photo).permit(:image)
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


