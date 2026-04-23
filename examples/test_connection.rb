# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "archivesspace/client"

# official sandbox
config = ArchivesSpace::Configuration.new(
  {
    base_uri: "https://test.archivesspace.org/staff/api",
    username: "admin",
    password: "admin",
    page_size: 50,
    throttle: 0,
    verify_ssl: false
  }
)

client = ArchivesSpace::Client.new(config).login

# globally scoped
puts client.get("version").body
puts client.get("repositories").body
puts client.all("users").map { |u| u["username"] }.to_a

# repo scoped
client.repository 2 do
  puts client.get("accessions", query: {page: 1}).parsed["results"].map { |a| a["uri"] }.to_a
end

# globally scoped, full path arg
puts client.get("repositories/2/resources", query: {all_ids: true}).body
