class Location < ApplicationRecord
    validates :name, :tagline, :description, presence: true   
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy
    has_many :ratings, dependent: :destroy
    has_many :photos, dependent: :destroy
end
