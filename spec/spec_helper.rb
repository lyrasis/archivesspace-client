# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'archivesspace/client'
require 'vcr'
require 'webmock/rspec'

# GLOBAL VALUES FOR SPECS
DEFAULT_BASE_URI = 'http://localhost:8089'
CUSTOM_BASE_URI  = 'https://archives.university.edu/api'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { record: :once }
end
