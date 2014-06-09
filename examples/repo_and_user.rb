#!/usr/bin/env ruby
require "archivesspace/client"
require "pp"

client          = ArchivesSpace::Client.new # localhost,  8089
client.login "admin", "admin"

########## EXAMPLES USING PROVIDED TEMPLATES

pp client.templates # view available templates

repository_with_agent = client.template_for "repository_with_agent"
repository_with_agent["repository"]["repo_code"] = "XYZ"
repository_with_agent["repository"]["name"] = "XYZ Archive"
repository_with_agent["agent_representation"]["names"][0]["primary_name"] = "XYZ"
repository_with_agent["agent_representation"]["names"][0]["sort_name"] = "XYZ"
repository_with_agent["agent_representation"]["agent_contacts"][0]["name"] = "Lionel Messi"

pp client.create "repository_with_agent", repository_with_agent
pp client.repositories_with_agent.find { |r| r["name"] =~ /xyz/i } 

user = client.template_for "user"
user["username"] = "lmessi"
user["name"] = "Lionel Messi"
user["is_admin"] = true
pp client.create "user", u, { password: "123456" }

user = client.users.find { |u| u.username =~ /messi/i }
user["name"] = "Cristiano Ronaldo"

pp client.update user

__END__

