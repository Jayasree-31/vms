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

before "deploy:assets:precompile", "deploy:yarn_install"

namespace :deploy do
  desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end
end
