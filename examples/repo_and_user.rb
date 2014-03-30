#!/usr/bin/env ruby
require "archivesspace/client"
require "pp"

host             = "localhost"
backend_port     = "8089" 
backend          = ArchivesSpace::Client.new( { site: "http://#{host}:#{backend_port}" } )
backend.user     = 'admin'
backend.password = 'admin'
backend.login

########## EXAMPLES USING PROVIDED TEMPLATES

pp backend.templates # view available templates

x = backend.template_for "repository"
x.repository["repo_code"] = "XYZ"
x.repository["name"] = "XYZ Archive"
x.agent_representation["names"][0]["primary_name"] = "XYZ"
x.agent_representation["names"][0]["sort_name"] = "XYZ"
x.agent_representation["agent_contacts"][0]["name"] = "Lionel Messi"

pp backend.create_from_template x
pp backend.repositories.find { |r| r.name =~ /xyz/i } 

u = backend.template_for "user"
u.username = "lmessi"
u.name = "Lionel Messi"
u.is_admin = true
pp backend.create_from_template u, { password: "123456" }
pp backend.users.find { |u| u.username =~ /messi/i } # see below for update example 

########## EXAMPLES WITH USER SUPPLIED DATA STRUCTURE

# repository: repo_code and name are required
# agent representation is not required at all
repo = {
  repository: {
    repo_code: "ABC",
    name: "ABC Archive",
    org_code: "",
    country: "US",
    parent_institution_name: "",
    url: "http://www.abc.org",
  },
  agent_representation: {
    names: [ { primary_name: "ABC Archive", source: "local", sort_name: "ABC Archive" } ],
    agent_contacts: [
      {
        name: "A User",
        address_1: "Some Deptartment",
        address_2: "Some street",
        address_3: "",
        city: "Some City",
        region: "Some State",
        country: "United States",
        post_code: "12345",
        telephone: "777-777-7777",
        telephone_ext: "",
        fax: "",
        email: "auser@abc.org",
        note: "",
      }
    ]
  }
}

pp backend.create(:repository, repo)
pp backend.repositories.find { |r| r.name =~ /abc/i }

# username and name are required
# password must be submitted via params
user = {
  username: "auser",
  name: "A User",
  email: "auser@abc.org",
  first_name: "A",
  last_name: "User",
  telephone: "777-777-7777",
  title: "Manager",
  department: "ABC Archive",
  additional_contact: "A good egg",
  is_admin: false,
}
pw = "654321"

pp backend.create(:user, user, { password: pw })
auser = backend.users.find { |u| u.username =~ /auser/i }

auser.title = "ABC Archive Manager"
pw = "123456"
pp backend.update(auser, { password: pw })

__END__

