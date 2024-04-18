# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "archivesspace/client/version"

Gem::Specification.new do |spec|
  spec.name = "archivesspace-client"
  spec.version = ArchivesSpace::Client::VERSION
  spec.authors = ["Mark Cooper"]
  spec.email = ["mark.c.cooper@outlook.com"]
  spec.summary = "Interact with ArchivesSpace via the API."
  spec.description = "Interact with ArchivesSpace via the API."
  spec.homepage = ""
  spec.license = "MIT"

  spec.bindir = "exe"
  spec.executables = %w[asclient]
  spec.files = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "aruba", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "3.6.0"
  spec.add_development_dependency "rubocop", "1.56"
  spec.add_development_dependency "standard", "1.31.0"
  spec.add_development_dependency "vcr", "6.2.0"
  spec.add_development_dependency "webmock", "3.19.1"

  spec.add_dependency "dry-cli", "~> 0.7"
  spec.add_dependency "httparty", "~> 0.14"
  spec.add_dependency "json", "~> 2.0"
  spec.add_dependency "nokogiri", "~> 1.10"
  spec.add_dependency "jbuilder", "~> 2.11.5"
end
