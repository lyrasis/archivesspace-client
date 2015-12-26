$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'archivesspace/client'

# default client connection: localhost:8089, admin, admin
client = ArchivesSpace::Client.new.login
client.config.throttle 0.5

client.config.base_repo = "repositories/2"
# date -d '2015-07-01 00:00:00' +'%s' # 1435734000
client.resources("ead", { query: { modified_since: "1435734000" } }) do |ead|
  # for now we are just printing ...
  # but you would actually write to a zip file or whatever
  ap ead
end