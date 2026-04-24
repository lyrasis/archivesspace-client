# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "archivesspace/client"
require "nokogiri"

# official sandbox
config = ArchivesSpace::Configuration.new(
  {
    base_uri: "https://test.archivesspace.org/staff/api",
    username: "admin",
    password: "admin",
    page_size: 50,
    throttle: 0,
    verify_ssl: false
  }
)

client = ArchivesSpace::Client.new(config).login
client.config.throttle = 0.5

begin
  client.repository 2 do
    # date -d '2021-02-01 00:00:00' +'%s' # 1612166400
    client.resources(query: {modified_since: "1612166400"}).each do |resource|
      # for now we are just printing ...
      # but you would actually write to a zip file or whatever
      id = resource["uri"].split("/")[-1]
      opts = {include_unpublished: false}
      response = client.get("resource_descriptions/#{id}.xml", opts)
      puts Nokogiri::XML(response.body).to_xml
    end
  end
rescue ArchivesSpace::RequestError => e
  puts e.message
end
