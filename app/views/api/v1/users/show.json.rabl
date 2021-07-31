object @user
attributes :name, :email, :mobile, :image_thumb_url
node(:id) {|c| c&.id&.to_s }
node(:registered_events_count) { |u| u.event_members_count }
