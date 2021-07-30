class UserRole
  include Mongoid::Document
  include Mongoid::Timestamps

  PRIMARY_ROLES = [
      "admin", "volunteer"
    ].freeze

  belongs_to :creator, class_name: "User", foreign_key: :created_by, optional: true
  belongs_to :modifier, class_name: "User", foreign_key: :modified_by, optional: true
  has_many :users

  field :name, type: String

  # validations
  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false
end
