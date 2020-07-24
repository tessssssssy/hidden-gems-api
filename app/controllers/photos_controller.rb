class PhotosController < ApplicationController
    before_action :authenticate_user, only: [:create, :destroy]
    before_action :set_photo, only: [:show, :update, :destroy]
    def index
        photos = Photo.where(location_id: params[:location_id])
    end

    def show
    end

    def create
        photo = Photo.new(photo_params)
        if location.save
            render json: { location: location, image: url_for(location.image) }, status: :created
          else
            render json: { errors: location.errors.full_messages }, status: :unprocessable_entity
          end
    end

    def delete
    end

    private

    def photo_params
        params.require(:photo).permit(:user_id, :location_id, :image)
    end
    
    def set_photo
        @location = Photo.find(params[:id])
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
