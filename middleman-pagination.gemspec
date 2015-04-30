# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman/pagination/version'

Gem::Specification.new do |spec|
  spec.name          = "middleman-pagination"
  spec.version       = Middleman::Pagination::VERSION
  spec.authors       = ["Pete Nicholls"]
  spec.email         = ["pete@metanation.com"]
  spec.description   = "General-purpose pagination support for Middleman pages."
  spec.summary       = "Pagination for Middleman pages."
  spec.homepage      = "https://github.com/Aupajo/middleman-pagination"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "middleman-core", "~> 3.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "middleman", "~> 3.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rack-test"
end
