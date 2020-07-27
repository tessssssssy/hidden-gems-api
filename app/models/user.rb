class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  def self.from_token_request request
    username = request.params['auth'] && request.params['auth']['username'] or email = request.params['auth'] && request.params['auth']['email']
    self.find_by username: username or self.find_by email: email
    end
  has_many :locations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :photos, dependent: :destroy
end


