# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "archivesspace/client"

# official sandbox
config = ArchivesSpace::Configuration.new(
  {
    base_uri: "https://sandbox.archivesspace.org/staff/api",
    base_repo: "",
    username: "admin",
    password: "admin",
    page_size: 50,
    throttle: 0,
    verify_ssl: false
  }
)

client = ArchivesSpace::Client.new(config).login

user_data = ArchivesSpace::Template.process("user.json.erb", {
  username: "bde",
  name: "BDE",
  is_admin: false
})

client.post("users", user_data, {password: "123456"})

users_with_roles = {
  "bde" => ["repository-basic-data-entry"]
}

begin
  client.config.base_repo = "repositories/2"
  results = client.group_user_assignment users_with_roles
  puts results.map(&:parsed)
rescue ArchivesSpace::RequestError => e
  puts e.message
end
