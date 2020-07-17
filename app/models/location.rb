class Location < ApplicationRecord
    validates :name, :tagline, :description, presence: true
    has_many :comments
    has_many :likes
    has_many :ratings
end
