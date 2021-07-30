# config valid for current version and patch releases of Capistrano
# lock "~> 3.12.1"
set :scm, :git
set :application, "vms"
set :repo_url, "git@github.com:Jayasree-31/vms.git"


# files we want symlinking to specific entries in shared.
set :linked_files, %w{config/boot.rb config/master.key config/credentials.yml.enc config/mongoid.yml }

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads public/images public/documents}

set(:config_files, %w(mongoid.yml))




# Default value for keep_releases is 5
set :keep_releases, 4

namespace :setup do
  desc "setup: copy config/master.key to shared/config"
  task :copy_linked_master_key do
    on roles(fetch(:setup_roles)) do
      sudo :mkdir, "-pv", shared_path
      upload! "config/master.key", "#{shared_path}/config/master.key"
      sudo :chmod, "600", "#{shared_path}/config/master.key"
    end
  end
  before "deploy:symlink:linked_files", "setup:copy_linked_master_key"
end
