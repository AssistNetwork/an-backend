# Usage: rake name:task app_name

task PROD = 'an-deployment-test'  # "task" here stubs to prevent rake errors with commandline
task STAGING = 'an-deployment-test'

APP = ARGV[1] || STAGING # default app

puts "=== APP #{APP} ==="

namespace :deploy do
  task :migrations => [:push, :off, :migrate, :restart, :on]

  # setup to be used with github or another repo (heroku repo is just used to deploy the code)
  # must setup remote tracking to work. git push -u origin branch
  task :push do
    git_status = `git branch -v`
    abort("local branch is out of sync with github origin. please push there first") if git_status.match(/\*[^\]]+?\[ahead|behind/s) != nil
    current_branch = `git rev-parse --abbrev-ref HEAD`.chomp
    current_branch += ":master" if current_branch != "master"
    puts "Deploying #{current_branch} to #{APP} ..."
    system("git push -f git@heroku.com:#{APP}.git #{current_branch}")
  end

  task :restart do
    puts 'Restarting app servers ...'
    system("heroku restart --app #{APP}")
  end

  task :migrate do
    puts 'Running database migrations ...'
    system("heroku run rake db:migrate --app #{APP}")
  end

  task :off do
    puts 'Putting the app into maintenance mode ...'
    system("heroku maintenance:on --app #{APP}")
  end

  task :on do
    puts 'Taking the app out of maintenance mode ...'
    system("heroku maintenance:off --app #{APP}")
  end

  task :rollback do
    puts 'rolling back to last version'
    system("heroku rollback --app #{APP}")
  end
end

namespace :app do
  task :logs do
    puts "tailing logs..."
    system("heroku logs --tail --app #{APP}")
  end

  task :config do
    puts "config..."
    system("heroku config --app #{APP}")
  end

  task :ps do
    puts "running processes..."
    system("heroku ps --app #{APP}")
  end

  task :releases do
    puts "releases..."
    system("heroku releases --app #{APP}")
  end
end