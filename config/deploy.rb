# deploy.rb - Capistrano config for The Colour Of.
# Copyright 2009 Rob Myers <rob@robmyers.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

################################################################################
# Config
################################################################################

set :application, "the_colour_of"
set :deploy_to, "/home/robmyers/daemons/#{application}"

set :scm, "git"
set :branch, "master"
set :repository,  "http://robmyers.org/git/the_colour_of.git"

set :runner, "robmyers"
set :domain, "robmyers.vm.bytemark.co.uk"
role :web, domain
role :app, domain
role :db, domain, :primary => true

################################################################################
# Rake
################################################################################

namespace :install_rake_task do
  task :add_cron_job do
    tmpname = "/tmp/appname-crontab.#{Time.now.strftime('%s')}"
    # run crontab -l or echo '' instead because the crontab command will fail if the user has no pre-existing crontab file.
    # in this case, echo '' is run and the cap recipe won't fail altogether.
    run "(crontab -l || echo '') | grep -v 'rake scrape' > #{tmpname}"
    run "echo '@hourly cd #{current_path} && RAILS_ENV=production rake my_rake_task' >> #{tmpname}"
    run "crontab #{tmpname}"
    run "rm #{tmpname}"
  end
end

namespace :rake do
  task :populate_db do
    run("cd #{deploy_to}/current; rake populate_db")
  end
end

################################################################################
# Passenger
################################################################################

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

################################################################################
# Configure the db yaml
################################################################################

namespace :deploy do
  task :after_update_code do
    db_yml_path = "#{current_path}/db/database.yml"
    db_yml = IO.read(db_yml_path)
    db_yml.sub!(/username:.*/, "username: #{Capistrano::CLI.ui.ask('Enter MySQL database user: ')}")
    db.yml.sub!(/password:.*/, "password: #{Capistrano::CLI.ui.ask('Enter MySQL database password: ')}")
    File.open(db_yml_path, 'w') {|f| f.write(db_yml) }
  end
end
