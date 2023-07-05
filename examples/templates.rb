# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "awesome_print"
require "archivesspace/client"

puts ArchivesSpace::Template.list

template = "repository_with_agent.json.erb"
user_data = {
  username: "harrykane",
  name: "Harry Kane",
  is_admin: false
}

puts ArchivesSpace::Template.process(template, user_data)
# or, if you really want ...
puts ArchivesSpace::Template::Erb.new(template, user_data).process
