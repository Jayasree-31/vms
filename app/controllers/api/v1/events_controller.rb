class Api::V1::EventsController < Api::BaseController
  before_action :set_event, only: [:show, :update, :edit, :add_member]

  # GET /events
  def index
    start_time =  Time.now
    end_time = Time.now + 50.days
    @events = Event.where(start_time: start_time..end_time)
  end

  def create
    @event = Event.new(event_params)
    @event.creator = current_user
    @event.category = Category.find(id: @event.category_id)
    if @event.save
      render :show
    else
      render json: { success: false, errors: "#{@event.errors.full_messages.join(', ')}" }
    end
  end

  def show

  end

  def edit

  end

  def add_member
    em = @event.event_members.new(user_id: params[:user_id])
    unless em.save
      return render json: { success: false, errors: "#{em.errors.full_messages.join(', ')}" }
    end
    render :show
  end

  def update
    if @event.update(event_params)
      render :show
    else
      render json: { success: false, errors: "#{@event.errors.full_messages.join(", ")}" }
    end
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(Event.editable_field_set) rescue []
    end

end
