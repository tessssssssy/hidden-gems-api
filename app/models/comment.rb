class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :location
  belongs_to :comment
end
