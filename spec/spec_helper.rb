require 'bundler/setup'
Bundler.setup

require 'archivesspace/client'
require 'rake'
require 'securerandom'
load File.expand_path("../../Rakefile", __FILE__)

RSpec.configure do |config|
  # Rake::Task["as:bs"].invoke
  # sleep 30 # give archivesspace some time to start
end
