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

set :application, "the_colour_of"
set :deploy_to, "/home/robmyers/daemons/#{application}"

set :scm, "git"
set :branch, "master"
set :repository,  "http://robmyers.org/git/the_colour_of.git"


#set :deploy_via, :remote_cache

#default_run_options[:pty] = true
#ssh_options[:forward_agent] = true

#load 'ext/rails-database-migrations.rb'
#load 'ext/rails-shared-directories.rb'
set :runner, "robmyers"
role :web, "robmyers.vm.bytemark.co.uk"
role :app, "robmyers.vm.bytemark.co.uk"
role :db, "robmyers.vm.bytemark.co.uk"

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
  task :show_tasks do
    run("cd #{deploy_to}/current; rake populate_db")
  end
end
