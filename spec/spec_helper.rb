require 'bundler/setup'
Bundler.setup

require 'archivesspace/client'
require 'rake'
require 'securerandom'
load File.expand_path("../../Rakefile", __FILE__)

RSpec.configure do |config|
  Rake::Task["as:bs"].invoke
  puts "waiting 30 seconds for bootstrap"
  sleep 30
  loop do
    begin
      response = RestClient.get 'http://localhost:8089'
      break if response.code == 200
    rescue Exception => ex
      puts "archivesspace is not ready ..."
      sleep 10
    end
  end

  config.after(:all) do
    ["stop", "rm"].each do |task|
      Rake::Task["as:#{task}"].reenable
      Rake::Task["as:#{task}"].invoke
    end
  end
end
