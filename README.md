# Archivesspace Client

Interact with ArchivesSpace via the API.

<!-- TOC start (generated with https://github.com/derlin/bitdowntoc) -->

* [Installation](#installation)
* [Usage](#usage)
   + [Configuring a client](#configuring-a-client)
      - [Default configuration](#default-configuration)
      - [Custom configuration, on the fly](#custom-configuration-on-the-fly)
      - [Custom configuration, stored for use with CLI or console](#custom-configuration-stored-for-use-with-cli-or-console)
   + [Making basic requests](#making-basic-requests)
   + [Setting a repository context](#setting-a-repository-context)
* [Templates](#templates)
* [CLI](#cli)
* [Console usage](#console-usage)
* [Development](#development)
* [Publishing](#publishing)
* [Contributing](#contributing)
* [License](#license)

<!-- TOC end -->

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

### Configuring a client

#### Default configuration

Create client with default settings (`localhost:8089`, `admin`, `admin`):

```ruby
client = ArchivesSpace::Client.new.login
```

#### Custom configuration, on the fly

```ruby
config = ArchivesSpace::Configuration.new({
  base_uri: "https://archives.university.edu/staff/api",
  username: "admin",
  password: "123456",
  page_size: 50,
  throttle: 0,
  verify_ssl: false,
  timeout: 60
})

client = ArchivesSpace::Client.new(config).login
```

**NOTE:** `ArchivesSpace::Configuration` allows you to set a `base_repo` value as well, but if this value is set in your config at the start, calls to API endpoints that do not include a repository id in the URI may not work correctly. It is recommended you set/unset the client repository as needed during use via the `#repository` method as described below. If you must set `base_repo` in the config used to create your client, note that the value should be like: "repositories/2", and not just the integer repository id.

#### Custom configuration, stored for use with CLI or console

Create a file containing JSON config data like:

```
{
  "base_uri": "http://localhost:4567",
  "username": "admin",
  "password": "myverysecurepassword",
  "page_size": 50,
  "throttle": 0,
  "timeout": 60,
  "verify_ssl": false,
  "debug": true
}
```

The CLI and console commands will, by default, look for this stored config at `~/.asclientrc`,

However, you may also set a custom location for the file by setting an ASCLIENT_CFG environment variable. This is handy if you prefer to use [XDG Base Directory Specification](https://xdgbasedirectoryspecification.com/), or have other opinions about where such config should live:

```
export ASCLIENT_CFG="$HOME/.config/archivesspace/client.json"
```


### Making basic requests

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

See `pagination.rb` for endpoints that support record type methods such as
`client.digital_objects` etc.

### Setting a repository context

Use the `repository` method to add a repository scope to requests (this is optional).

Instead of doing:

```ruby
client.get('repositories/2/digital_objects', query: {page: 1})
```

You can do:

```ruby
client.repository(2)
client.get('digital_objects', query: {page: 1})
```


To reset:

```ruby
client.repository(nil)
```

Or:

```ruby
client.use_global_repository
```

## Templates

Templates are an optional feature that can help simplify the effort of creating
json payloads for ArchivesSpace. Rather than construct the json programatically
according to the schemas a template can be used to generate payloads instead which
are transformed to json automatically. There are a small number of
templates provided with the client, but you can create your own and access them
by setting the `ARCHIVESSPACE_CLIENT_TEMPLATES_PATH` envvar. A particularly simple
`erb` template might look like:

```erb
{
  "digital_object_id": "<%= data[:digital_object_id] %>",
  "title": "<%= data[:title] %>"
}
```

Practically speaking there isn't much benefit to this example, but in the case of
a more complex record structure where you want to populate deeply nested elements
using a flat file structure (like csv) this can be a very convenient way of
assembling the payload. To process a template:

```ruby
data = { repo_code: 'ABC', name: 'ABC Archive', agent_contact_name: 'ABC Admin' }
json = ArchivesSpace::Template.process("repository_with_agent.json.erb", data)
response = client.post('/repositories/with_agent', json)
puts response.result.success? ? '=)' : '=('
```

To view available templates use: `ArchivesSpace::Template.list`

## CLI

Create a stored custom configuration to be used with the CLI as described above.

If you installed this client as a gem via the `gem install archivesspace-client` command, you should be able to use the `asclient` command directly.

If entering `asclient` in your terminal returns an error, you will need to use the CLI from within this repository:

```bash
cd path/to/archivesspace-client
./exe/asclient
```

The `asclient` command is self-documenting and will show you information about the currently supported commands.

To get more detailed usage info on a command:

```bash
asclient exec -h
```

## Console usage

Loading this application in console allows you to play around with its functionality interactively.

Create a stored custom configuration to be used with the console as described above. Then:

```bash
cd path/to/archivesspace-client
./bin/console
```

An IRB session opens. Entering the following should give you the backend version of the ArchivesSpace instance your stored custom config points to:

```
@client.backend_version
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

When an updated version (`lib/archivesspace/client/version.rb`) is merged into the
main/master branch a new release will be built and published.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lyrasis/archivesspace-client.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
