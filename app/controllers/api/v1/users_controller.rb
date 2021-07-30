class Api::V1::UsersController < Api::BaseController
  action_set = [:sign_in, :sign_up]
  skip_before_action :doorkeeper_authorize!, only: action_set
  before_action :authorize_application, only: action_set
  before_action :set_user, only: [:edit, :update]


  # POST /users/sign_in
  def sign_in
    @user = User.authenticate(user_params)
    if @user.present?
      @access_token = @user.get_access_token(@app)
    else
      render json: { success: false, errors: "Invalid credentials" }
    end
  end

  # POST /users/sign_up
  def sign_up
    @user = User.new(user_params)
    if @user.save
      @access_token = @user.get_access_token(@app)
      sign_in
    else
      render json: { success: false, errors: "#{@user.errors.full_messages.join(', ')}" }
    end
  end

  # DELETE /users/sign_out
  def sign_out
    if current_token.try(:revoke)
      render json: { success: true, message: "Logged out successfully" }
    else
      render json: { success: false, message: 'AccessToken not found' }
    end
  end

  # GET /users/:id
  def show
    @user = current_user
  end

  def update
    @user.modifier = current_user
    if @user.update(user_params)
      render :show
    else
      render json: { success: false, errors: "#{@user.errors.full_messages.join(', ')}" }
    end
  end

  # GET /users
  def index
    user_role = UserRole.where(name: "volunteer").last
    @users = user_role.users
  end

  private
    def user_params
      params.require(:user).permit(User.editable_field_set) rescue []
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end
end
