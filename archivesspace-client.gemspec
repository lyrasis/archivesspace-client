# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'archivesspace/client/version'

Gem::Specification.new do |spec|
  spec.name          = "archivesspace-client"
  spec.version       = ArchivesSpace::Client::VERSION
  spec.authors       = ["Mark Cooper"]
  spec.email         = ["mark.c.cooper@outlook.com"]
  spec.summary       = %q{Interact with ArchivesSpace via its RESTful API.}
  spec.description   = %q{Interact with ArchivesSpace via its RESTful API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "awesome_print"

  spec.add_dependency "httparty"
  spec.add_dependency "json"
  spec.add_dependency "nokogiri"
end
