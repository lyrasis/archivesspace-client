require 'bundler/setup'
Bundler.setup

require 'archivesspace/client'
require 'rake'
load File.expand_path("../../Rakefile", __FILE__)

RSpec.configure do |config|
  Rake::Task["archivesspace:check_downloaded"].invoke
end
