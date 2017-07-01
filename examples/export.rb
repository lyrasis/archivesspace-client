$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'awesome_print'
require 'archivesspace/client'

# official sandbox
config = ArchivesSpace::Configuration.new({
  base_uri: "http://sandbox.archivesspace.org/api",
  base_repo: "",
  username: "admin",
  password: "admin",
  page_size: 50,
  throttle: 0,
  verify_ssl: false,
})

client = ArchivesSpace::Client.new(config).login
client.config.throttle = 0.5
client.config.base_repo = "repositories/2"

begin
  # date -d '2015-07-01 00:00:00' +'%s' # 1435734000
  client.resources("ead", { query: { modified_since: "1435734000" } }) do |ead|
    # for now we are just printing ...
    # but you would actually write to a zip file or whatever
    ap ead
  end
rescue ArchivesSpace::RequestError => ex
  puts ex.message
end