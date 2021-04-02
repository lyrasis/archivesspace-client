# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'awesome_print'
require 'archivesspace/client'

# official sandbox
config = ArchivesSpace::Configuration.new(
  {
    base_uri: 'http://test.archivesspace.org/staff/api',
    base_repo: '',
    username: 'admin',
    password: 'admin',
    page_size: 50,
    throttle: 0,
    verify_ssl: false
  }
)

client = ArchivesSpace::Client.new(config).login
client.config.throttle = 0.5
client.config.base_repo = 'repositories/2'

begin
  # date -d '2021-02-01 00:00:00' +'%s' # 1612166400
  client.resources(query: { modified_since: '1612166400' }).each do |resource|
    # for now we are just printing ...
    # but you would actually write to a zip file or whatever
    id   = resource['uri'].split('/')[-1]
    opts = { include_unpublished: false }
    response = client.get("resource_descriptions/#{id}.xml", opts)
    puts Nokogiri::XML(response.body).to_xml
  end
rescue ArchivesSpace::RequestError => e
  puts e.message
end
