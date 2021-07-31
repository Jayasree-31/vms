class EventMember
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :event, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :user_point_transactions

  after_create :set_points

  validates_uniqueness_of :user_id, case_sensitive: false, scope: :event_id

  def set_points
    ups = self.user_point_transactions.new(txn_points: rand(0..self.event.reward_points), txn_type: "Earn", user_id: self.user_id)
    ups.save
  end

end
