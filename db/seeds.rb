require 'highline/import'
UserRole::PRIMARY_ROLES.each do |name|
  UserRole.find_or_create_by(name: name)
end
puts "UserRoles created successfully"

if User.count.zero?
  puts "Enter admin email:"
  email = STDIN.gets.chomp
  password = ask("Password:  ") { |q| q.echo = "*" }
  password ||= "password"
  user_role = UserRole.find_by(name: "admin") rescue []
  puts "User Created successfully" if User.create(email: email, password: password, user_role: user_role)
end

if Category.count.zero?
  a = 10.times.map { |s| s * 100 }
  categories = [
      "Health Service", "Yoga Session", "Emergencies", "Environment", "Animal Welfare", "Social Service"
    ]
  categories.each do |cat|
    Category.create(name: cat, reward_points: a.sample)
  end
end


if Doorkeeper::Application.count.zero?
  app = Doorkeeper::Application.new :name => 'VMS', :redirect_uri => 'app://vms/redirect'
  app.save
end

