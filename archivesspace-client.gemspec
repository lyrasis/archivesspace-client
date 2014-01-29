# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'archivesspace/client/version'

Gem::Specification.new do |spec|
  spec.name          = "archivesspace-client"
  spec.version       = Archivesspace::Version::VERSION
  spec.authors       = ["Mark Cooper"]
  spec.email         = ["markchristophercooper@gmail.com"]
  spec.summary       = %q{Interact with ArchivesSpace via its RESTful API.}
  spec.description   = %q{Interact with ArchivesSpace via its RESTful API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
