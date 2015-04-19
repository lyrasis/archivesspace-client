require "bundler/gem_tasks"

namespace :as do

  archivesspace_docker_image = "markcooper/archivesspace"

  desc "bootstrap archivesspace"
  task :bootstrap do
    Rake::Task["as:pull"].invoke
    Rake::Task["as:stop"].invoke
    Rake::Task["as:rm"].invoke
    Rake::Task["as:run"].invoke
  end
  task :bs => :bootstrap

  desc "ping to see if archivesspace backend is available"
  task :ping do
    response = RestClient.get 'http://localhost:8089'
    puts response.code
    response.code
  end

  desc "pull archivesspace docker image"
  task :pull do
    sh "docker pull #{archivesspace_docker_image}"
  end

  desc "run archivesspace docker image"
  task :run do
    puts "starting archivesspace (see: docker logs -f archivesspace)"
    `docker run --name archivesspace -d -p 8089:8089 #{archivesspace_docker_image}`
  end

  desc "stop archivesspace docker image"
  task :stop do
    puts "stopping archivesspace"
    `docker stop archivesspace`
  end

  desc "remove archivesspace docker image"
  task :remove do
    puts "removing archivesspace image"
    `docker rm archivesspace`
  end
  task :rm => :remove

end
