# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "archivesspace/client"

username = "admin"
password = "admin"

# default client connection: localhost:8089, admin, admin
client = ArchivesSpace::Client.new.login
begin
  puts client.password_reset(username, password).parsed
rescue => e
  puts "Failed to update password for #{username},\n#{e.message}"
end
