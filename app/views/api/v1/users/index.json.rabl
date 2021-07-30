collection @users
attributes :name, :email, :mobile, :dob, :gender, :image_thumb_url
node(:id) {|c| c.id.to_s }
node(:user_role) { |u| u.user_role.try(:name)}
node(:registered_events_count) { |u| u.event_members_count }
