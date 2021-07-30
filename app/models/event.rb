class Event
  include Mongoid::Document
  include Mongoid::Timestamps

  # Requires a field search_field_set set to work
  # Requires index({ search_data: "text" }) for index
  include Searchable

  mount_uploader :image, ImageUploader

  field :name, type: String
  field :description, type: String
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :members_needed, type: String
  field :location, type: String
  field :event_members_count, type: Integer, default: 0
  field :image, type: String

  belongs_to :category
  belongs_to :creator, class_name: 'User', foreign_key: :created_by, optional: true
  belongs_to :modifier, class_name: "User", foreign_key: :modified_by, optional: true
  has_many :event_members

  validates :name, :start_time, :end_time, :description, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  index({ search_data: "text" })

  def self.editable_field_set
    [ :name, :description, :start_time, :end_time,
      :members_needed, :location, :category_id,
      :image, :image_cache
    ]
  end
end
