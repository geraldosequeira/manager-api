class Task < ApplicationRecord
  
  belongs_to :user

  validates :title, :user, presence: true
end
