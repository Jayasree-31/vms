object @event
attributes :name, :description, :start_time, :end_time, :location, :image_thumb_url, :reward_points
node(:id) { |e| e.id.to_s }
node(:creator) { |e| e.creator&.name || e.creator&.email }
node(:total_members_needed) { |e| e.members_needed }
node(:registered_members_count) { |e| e.event_members_count }

child(:event_members, object_root: false) do
  node(:id) {|x| x.user.id.to_s}
  node(:email) {|x| x.user.email}
  node(:name) {|x| x.user.name}
end

child :category do
  attributes :name
end
