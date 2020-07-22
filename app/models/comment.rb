class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :location
  has_many :attached_comments, class_name: "Comment", foreign_key: "thread_id"
  belongs_to :thread, class_name: "Comment", optional: true
  validates :body, presence: true, length: { in: 3..500 }
end
