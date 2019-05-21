class Api::V2::TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :done, :deadline, :user_id

  belongs_to :user
end
