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

user_data = {
  username: 'bde',
  name: 'BDE',
  is_admin: false
}

client.post(
  'users',
  ArchivesSpace::Template.process(:user, user_data),
  { password: '123456' }
)

users_with_roles = {
  'bde' => ['repository-basic-data-entry']
}

begin
  client.config.base_repo = "repositories/2"
  results = client.group_user_assignment users_with_roles
  ap results.map(&:parsed)
rescue ArchivesSpace::RequestError => e
  puts e.message
end
