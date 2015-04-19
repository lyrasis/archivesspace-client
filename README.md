Archivesspace Client
====================

Interact with ArchivesSpace via its API.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'archivesspace-client', :git => "https://github.com/mark-cooper/archivesspace-client.git"
```

And then execute:

```bash
bundle install
```

Or pull the repository and install it yourself:

```bash
gem build archivesspace-client.gemspec
gem install archivesspace-client-VERSION.gem
```

Usage
-----

See the examples directory. Quick examples:

```ruby
client = ArchivesSpace::Client.new # default http://localhost, 8089
client = ArchivesSpace::Client.new https://secure.archive.org, 443, "api/" # https

client.log # log requests
client.login "admin", "admin"

# create a new repository
new_repo = client.template_for "repository"
new_repo["repo_code"] = "ABC"
new_repo["name"] = "ABC Archives"
client.create "repository", new_repo

# find and display the repository that was just created
repository = client.repositories.find { |repository| repository["repo_code"] =~ /^A/ }
pp repository

# set this repository as the context for repository based requests
client.working_repository repository
pp client.groups

# display version information
pp client.version

# users
users = client.users( { page: 1 } )
```

Tests (under development)
-----------------------------------

```bash
bundle exec rspec
```

Requires Docker.

---
