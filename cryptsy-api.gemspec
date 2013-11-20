# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cryptsy/api/version'

Gem::Specification.new do |spec|
  spec.name          = "cryptsy-api"
  spec.version       = Cryptsy::API::VERSION
  spec.authors       = ["Nic Barthelemy"]
  spec.email         = ["nbarthel@axomi.com"]
  spec.description   = %q{A ruby implementation of the Cryptsy API}
  spec.summary       = %q{Covers all API calls at http://www.cryptsy.com/pages/api}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'httparty'
  spec.add_dependency 'json'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mini_shoulda"

  spec.required_ruby_version = '>=1.9'
end
