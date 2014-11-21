Archivesspace Client
====================

Interact with ArchivesSpace via its API.

Installation
------------

Add this line to your application's Gemfile:

```
gem 'archivesspace-client', :git => "https://github.com/mark-cooper/archivesspace-client.git"
```

And then execute:

```
bundle install
```

Or pull the repository and install it yourself:

```
gem build archivesspace-client.gemspec
gem install archivesspace-client-VERSION.gem
```

Usage
--------

See the examples directory. Quick examples:

```
client = ArchivesSpace::Client.new # default http://localhost, 8089
# https with path example
client = ArchivesSpace::Client.new https://secure.archive.org, 443, "api/"

client.log # log requests
client.login "admin", "admin"

new_repo = client.template_for "repository"
new_repo["repo_code"] = "ABC"
new_repo["name"] = "ABC Archives"

client.create "repository", new_repo

# find the repository that was just created
repository = client.repositories.find { |repository| repository["repo_code"] =~ /^A/ }
pp repository # display the json response

client.working_repository repository # set this repository as the context for repository based requests
pp client.groups # spit out repository groups

pp client.version # display version information

users = client.users( { page: 1 } ) # start at the beginning will retrive all users
```

Tests (under development)
-----------------------------------

See the Rakefile for how to download and have ArchivesSpace running locally for testing.

```
rake archivesspace:prepare # download, unzip, configure
rake archivesspace:reset # stop, clear, start
```

The goal is to have this be a seamless process, when time allows.

---
