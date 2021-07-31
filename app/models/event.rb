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
  field :reward_points, type: Integer
  field :city, type: String
  field :region_name, type: String
  field :ip, type: String
  field :country_code, type: String
  field :country_name, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :zip, type: String

  belongs_to :category
  belongs_to :creator, class_name: 'User', foreign_key: :created_by, optional: true
  belongs_to :modifier, class_name: "User", foreign_key: :modified_by, optional: true
  has_many :event_members

  validates :name, :start_time, :end_time, :description, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  index({ search_data: "text" })

  before_save :set_points
  after_create :set_location

  def self.editable_field_set
    [ :name, :description, :start_time, :end_time,
      :members_needed, :location, :category_id,
      :image, :image_cache, :reward_points, :city, :region_name, :zip, :country_code, :country_name, :latitude, :longitude
    ]
  end

  def search_field_set
    [:name, :description, :location, :city, :region_name, :zip, :country_code, :country_name, :latitude, :longitude, :location]
  end

  def image_url
    ENV["host"] + image.url rescue nil
  end

  def image_thumb_url
    # hardcode
    "https://team-d.nighthack.in" + ActionController::Base.helpers.asset_path("event.jpg") rescue nil
  end

  private

  def set_points
    a = 10.times.map { |s| s * 100 }
    self.reward_points = a.sample
  end

  def set_location
    return if self.ip.blank?
    ENV['IPSTACK_ACCESS_KEY'] = "f8f90fa5ff481742e57d2648b499a65d"
    begin
      data = Ipstack::API.standard(self.ip, {fields: 'city,region_name,zip,ip,country_code,country_name,latitude,longitude'})
      return if data["success"] == false
      self.city = data["city"]
      self.region_name =  data["region_name"]
      self.zip =  data["zip"]
      self.country_code =  data["country_code"]
      self.country_name =  data["country_name"]
      self.latitude =  data["latitude"]
      self.longitude =  data["longitude"]
      self.location =  "#{data["city"]}, #{data["region_name"]}, #{data["zip"]}, #{data["country_code"]}, #{data["country_name"]}, #{data["latitude"]}, #{data["longitude"]} }"
      self.save
    rescue => e
      { success: false, error: e.message }
    end
  end
end
