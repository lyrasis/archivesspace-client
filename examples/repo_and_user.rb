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

puts ArchivesSpace::Template.list # view available templates

repo_data = {
  repo_code: "XYZ",
  name: "XYZ Archive",
  agent_contact_name: "XYZ Admin"
}

user_data = {
  username: "lmessi",
  name: "Lionel Messi",
  is_admin: true
}
user_password = "123456"

repository = ArchivesSpace::Template.process("repository_with_agent.json.erb", repo_data)

begin
  response = client.post("/repositories/with_agent", repository)
  if response.result.success?
    repository = client.repositories.find { |r| r["repo_code"] == "XYZ" }
    puts repository
    puts client.delete(repository["uri"])
  else
    puts response.parsed
  end

  user = ArchivesSpace::Template.process("user.json.erb", user_data)
  response = client.post("users", user, {password: user_password})
  if response.result.success?
    user = client.users.find { |r| r["username"] == "lmessi" }
    puts user
    puts client.delete(user["uri"]).inspect
  else
    puts response.parsed
  end
rescue ArchivesSpace::RequestError => e
  puts e.message
end
