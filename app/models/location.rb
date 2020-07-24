class Location < ApplicationRecord
    validates :name, :tagline, :description, presence: true   
    belongs_to :user, dependent: :destroy
    has_many :comments
    has_many :likes
    has_many :ratings
    has_many :photos
end
