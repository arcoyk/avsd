# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'avsd/version'

Gem::Specification.new do |spec|
  spec.name          = "avsd"
  spec.version       = Avsd::VERSION
  spec.authors       = ["arcoyk"]
  spec.email         = ["yuikita21@gmail.com"]

  spec.summary       = %q{fff}
  spec.description   = %q{fff}
  spec.homepage      = "http://list300.xyz"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
