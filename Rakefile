# frozen_string_literal: true

require "bundler/gem_tasks"

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

# require 'rubocop/rake_task'
# RuboCop::RakeTask.new

require "cucumber/rake/task"
Cucumber::Rake::Task.new

require "standard/rake"

task default: %i[spec cucumber]

task :version do
  puts ArchivesSpace::Client::VERSION
end
