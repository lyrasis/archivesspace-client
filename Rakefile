require "bundler/gem_tasks"

namespace :archivesspace do

  task :check_downloaded do
    unless File.file? "archivesspace.zip"
      Rake::Task["archivesspace:prepare"].invoke
    end
  end

  task :check_running do
    #
  end

  task :download do
    `wget -O archivesspace.zip https://github.com/archivesspace/archivesspace/releases/download/v1.2.0/archivesspace-v1.2.0.zip`
  end

  task :unzip do
    `unzip archivesspace.zip`
  end

  task :setup do
    `echo "AppConfig[:enable_frontend] = false" >> archivesspace/config/config.rb`
    `echo "AppConfig[:enable_public] = false" >> archivesspace/config/config.rb`
  end

  task :start do
    `./archivesspace/archivesspace.sh start`
  end

  task :stop do
    `./archivesspace/archivesspace.sh stop`
  end

  task :nuke do
    `rm -rf archivesspace/data/*`
  end

  task :prepare do
    Rake::Task["archivesspace:download"].invoke
    Rake::Task["archivesspace:unzip"].invoke
    Rake::Task["archivesspace:setup"].invoke
  end

  task :reset do
    Rake::Task["archivesspace:stop"].invoke
    Rake::Task["archivesspace:nuke"].invoke
    Rake::Task["archivesspace:start"].invoke
  end

  task :cleanup do
    `rm -rf archivesspace/`
    `rm archivesspace.zip`
  end

end
