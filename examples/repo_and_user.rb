$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'archivesspace/client'

# default client connection: localhost:8089, admin, admin
client = ArchivesSpace::Client.new.login

ap ArchivesSpace::Template.list # view available templates

repo_data = {
  repo_code: "XYZ",
  name: "XYZ Archive",
  agent_contact_name: "John Doe",
}

user_data = {
  username: "lmessi",
  name: "Lionel Messi",
  is_admin: true,
}
user_password = "123456"

repository = ArchivesSpace::Template.process_template(:repository_with_agent, repo_data)

begin
  response = client.post('/repositories/with_agent', repository)
  if response.status_code == 201
    repository = client.repositories.find { |r| r["repo_code"] == "XYZ" }
    ap repository
    ap client.delete(repository["uri"])
  else
    ap response.parsed
  end

  user = ArchivesSpace::Template.process_template(:user, user_data)
  response = client.post('users', user, { password: user_password })
  if response.status_code == 201
    user = client.users.find { |r| r["username"] == "lmessi" }
    ap user
    ap client.delete user["uri"]
  else
    ap response.parsed
  end
rescue ArchivesSpace::RequestError => ex
  puts ex.message
end
