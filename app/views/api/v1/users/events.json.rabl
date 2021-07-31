object @user
node(:id) {|c| c.id.to_s }
node(:upcoming_events) { |c| @event_details[:upcoming_events] }
node(:past_events) { |u| @event_details[:past_events] }

