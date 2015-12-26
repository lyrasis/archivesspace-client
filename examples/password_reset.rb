$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'archivesspace/client'

username = "mrx"
password = "123456"

# default client connection: localhost:8089, admin, admin
client = ArchivesSpace::Client.new.login
begin
  client.password_reset username, password
  puts "Successfully updated password for #{username}."
rescue Exception => e
  puts "Failed to update password for #{username},\n#{e.message}"
end
