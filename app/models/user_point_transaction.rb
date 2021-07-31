class UserPointTransaction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :txn_type, type: String
  field :txn_points, type: Integer, default: 0

  belongs_to :user
  belongs_to :coupon_id, optional: true
  belongs_to :event_member, optional: true
  belongs_to :event, optional: true

  validates :txn_type, :txn_points, presence: true

  after_save :update_user_points


  def update_user_points
    up = self.user.user_point
    if up.nil?
      up = UserPoint.new
    end
    if self.txn_type == "Earn"
      up.points_earned = self.txn_points
      up.remaining_points = up.remaining_points > 0 ? (up.remaining_points + self.txn_points) : self.txn_points
    elsif self.txn_type == "Burn"
      up.points_burned = self.txn_points
      up.remaining_points = up.remaining_points > 0 ? (up.remaining_points - self.txn_points) : 0
    end
    self.user.user_point = up
    self.user.save
  end
end
