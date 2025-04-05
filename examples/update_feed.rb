# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "archivesspace/client"

config = ArchivesSpace::Configuration.new(
  {
    base_uri: "https://test.archivesspace.org/staff/api",
    base_repo: "",
    username: "admin",
    password: "admin",
    page_size: 50,
    throttle: 0,
    verify_ssl: false
  }
)

client = ArchivesSpace::Client.new(config).login
response = client.get("update-feed")
last_sequence = response.parsed[0]["sequence"] # get initial sequence value

# This is an example only, would also need to handle session/token expiration
loop do
  puts "Using sequence: #{last_sequence}"
  begin
    response = client.get("update-feed", query: {last_sequence: last_sequence})
    if response.result.success?
      last_sequence = response.parsed.last["sequence"]
      # do something with the response
      puts response.parsed.to_json
    end
  rescue Net::ReadTimeout
    # this is ok if no updates are made within the last 60 seconds
    # (well, as defined by the timeout in client/AppConfig)
  rescue => e
    # some other kind of error occurred
    puts e.message
    break # or handle it in some other way
  end
end
