class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :location, dependent: :destroy
  has_one_attached :image
end


