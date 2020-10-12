# Archivesspace Client

Interact with ArchivesSpace via the API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'archivesspace-client'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install archivesspace-client
```

## Usage

See the examples directory for a range of use cases.

**Default configuration**

Create client with default settings (`localhost:8089`, `admin`, `admin`):

```ruby
client = ArchivesSpace::Client.new.login
```

**Custom configuration**

```ruby
config = ArchivesSpace::Configuration.new({
  base_uri: "https://archives.university.edu/api",
  base_repo: "",
  username: "admin",
  password: "123456",
  page_size: 50,
  throttle: 0,
  verify_ssl: false,
})

client = ArchivesSpace::Client.new(config).login
```

**Making basic requests**

The client responds to the standard request methods:

```ruby
client.post('users', payload, { password: "abc123" }) # CREATE
client.get('users/5') # READ
client.post('users/5', payload) # UPDATE
client.delete('users/5') # DELETE

# these all defer to `request`
client.request('GET', 'users/5')

# to add params
client.get('users', { query: { all_ids: true } }).parsed

# using convenience methods
user = client.all('users').find { |user| user["username"] == "jdoe" }

# or even ...
user = client.users.find { |user| user["username"] == "jdoe" }
```

See `helpers.rb` for more convenience methods such as `client.digital_objects` etc.

**Setting a repository context**

Update the `base_repo` configuration value to add a repository scope to requests (this is optional).

```ruby
client.config.base_repo = "repositories/2"
client.get('digital_objects') # instead of "repositories/2/digital_objects" etc.

# to reset
client.config.base_repo = ""
```

## Development

To run the examples start a local instance of ArchivesSpace then:

```bash
bundle exec ruby examples/repo_and_user.rb
```

Any script placed in the examples directory with a `my_` prefix are ignored by
git. Follow the convention used by the existing scripts to bootstrap and
experiment away.

To run the tests:

```bash
bundle exec rake
```

## Publishing

Bump version in `lib/archivesspace/client/version.rb` then:

```bash
VERSION=0.1.6
gem build archivesspace-client
git add . && git commit -m "Bump to $VERSION"
git tag v$VERSION
git push origin master
git push --tags
gem push archivesspace-client-$VERSION.gem
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lyrasis/archivesspace-client.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
