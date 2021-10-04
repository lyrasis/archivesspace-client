# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'archivesspace/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'archivesspace-client'
  spec.version       = ArchivesSpace::Client::VERSION
  spec.authors       = ['Mark Cooper']
  spec.email         = ['mark.c.cooper@outlook.com']
  spec.summary       = 'Interact with ArchivesSpace via the API.'
  spec.description   = 'Interact with ArchivesSpace via the API.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'awesome_print', '~> 1.8.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'capybara_discoball'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'json_spec'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '3.6.0'
  spec.add_development_dependency 'vcr', '3.0.3'
  spec.add_development_dependency 'webmock', '3.0.1'

  spec.add_dependency 'dry-cli', '~> 0.7'
  spec.add_dependency 'httparty', '~> 0.14'
  spec.add_dependency 'json', '~> 2.0'
  spec.add_dependency 'nokogiri', '~> 1.10'
end
