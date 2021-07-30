class Category
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :reward_points, type: Integer

  has_many :events
  belongs_to :creator, class_name: 'User', foreign_key: :created_by, optional: true
  belongs_to :modifier, class_name: "User", foreign_key: :modified_by, optional: true

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
