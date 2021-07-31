class UserPoint
  include Mongoid::Document
  include Mongoid::Timestamps

  field :points_earned, type: Integer, default: 0
  field :points_burned, type: Integer, default: 0
  field :remaining_points, type: Integer, default: 0

  embedded_in :user
end
