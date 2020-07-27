class Photo < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_one_attached :image
end
