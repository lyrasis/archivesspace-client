# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'awesome_print'
require 'archivesspace/client'

# official sandbox
config = ArchivesSpace::Configuration.new(
  {
    base_uri: 'http://sandbox.archivesspace.org/api',
    base_repo: '',
    username: 'admin',
    password: 'admin',
    page_size: 50,
    throttle: 0,
    verify_ssl: false
  }
)

client = ArchivesSpace::Client.new(config).login
puts client.get('version').body
