class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  def self.from_token_request(request)
    username = request.params["auth"] && request.params["auth"]["username"]
    self.find_by(username: username)
  end
  has_many :comments
  has_many :likes
  has_many :ratings
end


