class LocationsController < ApplicationController
  before_action :authenticate_user, only: %i[create update destroy]
  before_action :set_location, only: %i[show update destroy]

  def index
    p params
    errors = nil
    if params[:longitude]
      params[:km] != "undefined" ? km = params[:km] : km = 50
      rawLocation = Location.near([params[:latitude].to_f, params[:longitude].to_f], km.to_i, units: :km).order(id: 'desc').includes(:ratings, :user)
      if rawLocation.length === 0
        errors = 'No result found'
      end
    else
      rawLocation = Location.all.order(id: 'desc').includes(:ratings, :user)
    end
    @locations = rawLocation.map do |l|
      photos = Photo.where(location_id: l.id)
      photos = generate_image_urls(photos)
      location = l.as_json
      location = location.merge({ photos: photos, ratings: l.ratings.average(:stars).to_i, numberOfRatings: l.ratings.count, username: l.user.username })
    end
    render json: { locations: @locations, errors: errors }, status: 200
  end

  def show
    location = @location.as_json
    photos = Photo.where(location_id: @location.id)
    photos = generate_image_urls(photos)
    location = location.merge({ photos: photos, ratings: @location.ratings.average(:stars).to_i, numberOfRatings: @location.ratings.count, username: @location.user.username })

    rawComment = Comment.includes(:user).where(location_id: @location.id)
    if rawComment.empty?
      comments = [0]
    else
      rawComment.map do |c|
        comment = c.as_json
        comment = comment.merge({ username: c.user.username })
      end
    end
    render json: { location: location, comments: comments }, status: 200
  end

  def create
    if params[:location][:image] === 'undefined'
      render json: { errors: 'No photo attached' }, status: :unprocessable_entity
    else
      @location = current_user.locations.new(location_params)
      if @location.save
        photo = current_user.photos.new(location_id: @location.id, image: params[:location][:image], main: true)
        if photo.save
          location = @location.as_json
          location = location.merge({ photos: [url_for(photo.image)], username: @location.user.username })
          render json: { location: location }, status: :created
        else
          location.destroy
          render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { errors: location.errors.full_messages }, status: :unprocessable_entity
        end
    end
  end

  def update
    photo = Photo.find_by(location_id: params[:id], main: true)
    image = params[:location][:image]
    image = photo.image_attachment.blob if image === 'undefined'
    if @location.update(location_params) && photo.update(image: image)
      location = @location.as_json
      location = location.merge({ photos: [url_for(photo.image)], username: @location.user.username })
      render json: { location: location }, status: :ok
    else
      render json: { errors: @location.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    render json: 'location deleted', status: :ok
  end

  private

  def location_params
    params.require(:location).permit(:name, :description, :tagline, :address, :longitude, :latitude, :category)
  end

  def photo_params
    params.require(:photo).permit(:image)
  end

  def set_location
    @location = Location.find(params[:id])
  end

  def generate_image_urls(photos)
    photos.map do |photo|
      photo.attributes.merge(image: url_for(photo.image), username: photo.user.username)
    end
  end
end
