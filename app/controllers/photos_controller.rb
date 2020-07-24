class PhotosController < ApplicationController
    before_action :authenticate_user, only: [:create, :destroy]
    before_action :set_photo, only: [:show, :update, :destroy]

    def index
        photos = Photo.where(location_id: params[:location_id])
        photos = generate_image_urls(photos)
        render json: photos, status: 200
    end

    def show
        render json: photo.merge({image: image.service_url})
    end

    def create
        byebug
        photo = current_user.photos.new(photo_params)
        if photo.save
            render json: { photo: photo, image: url_for(photo.image) }, status: :created
          else
            render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        photo.destroy
        render json: "photo deleted", status: :ok
    end

    private

    def photo_params
        params.require(:photo).permit(:location_id, :image)
    end
    
    def set_photo
        photo = Photo.find(params[:id])
    end

    def generate_image_urls(photos)
        photos.map do |photos|
            photo.attributes.merge(image: url_for(photo.image))
        end
    end
end
