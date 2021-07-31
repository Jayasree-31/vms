class User
  include Mongoid::Document
  include Mongoid::Timestamps

  include Searchable

  mount_uploader :image, ImageUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  belongs_to :creator, class_name: 'User', foreign_key: :created_by, optional: true
  belongs_to :modifier, class_name: "User", foreign_key: :modified_by, optional: true
  belongs_to :user_role

  field :name, type: String
  field :mobile, type: String
  field :dob, type: Date
  field :gender, type: String
  field :location, type: String
  field :event_members_count, type: Integer, default: 0
  field :image, type: String
  field :city, type: String
  field :region_name, type: String
  field :ip, type: String
  field :country_code, type: String
  field :country_name, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :zip, type: String

  # Validations
  validates :email, presence: true
  validate :validate_email_and_mobile

  # Callbacks
  before_validation :set_role
  after_create :set_location


  embeds_one :user_point
  has_many :event_members
  has_many :user_point_transactions

  index({ search_data: "text" })

  def self.editable_field_set
    [
      :name, :email, :mobile, :dob, :gender,
        :password, :password_confirmation, :location,
        :image, :image_cache, :ip, :city, :region_name, :zip, :country_code, :country_name, :latitude, :longitude
    ]
  end

  def search_field_set
    [:name, :location, :city, :region_name, :zip, :country_code, :country_name, :latitude, :longitude, :location]
  end

   # Api auth specific methods
  def self.authenticate(params)
    user = User.find_for_authentication(email: params[:email])
    unless user.blank?
      return user if user.valid_password?(params[:password])
    else
      user = nil
    end
  end

  def get_access_token(app)
    Doorkeeper::AccessToken.where(application_id: app.id, resource_owner_id: self.id).destroy_all
    Doorkeeper::AccessToken.find_or_create_for(app, self.id,
      'user read, update and write preference', 90.days, true)
  end

  def set_role
    self.user_role = UserRole.where(name: "volunteer").first if self.user_role.blank?
  end

  def image_url
    ENV["host"] + image.url rescue nil
  end

  def image_thumb_url
    # hardcode
    img = "https://team-d.nighthack.in" + ActionController::Base.helpers.asset_path("user.jpg") rescue nil
  end

  def events
    event_ids = self.event_members.pluck(:event_id)
    events = Event.where(id: {"$in": event_ids})
  end

  private
    def validate_email_and_mobile
      errors.add(:email, "must be a valid format") if self.email.present? and not !!(self.email.match(/\A[\w.+-]+@\w+\.\w+\z/))
      errors.add(:mobile, "must be a valid format") if self.mobile.present? and not !!(self.mobile.match(/\d{10}$/))
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
