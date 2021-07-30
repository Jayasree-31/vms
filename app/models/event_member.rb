class EventMember
  include Mongoid::Document
  include Mongoid::Timestamps

  field :points_earned, type: Integer, default: 0

  belongs_to :event, counter_cache: true
  belongs_to :user, counter_cache: true

end
