class Location < ApplicationRecord
    validates :name, :tagline, :description, presence: true
    belongs_to :user
    has_many :comments
    has_many :likes
    has_many :ratings
    has_one_attached :image
end
