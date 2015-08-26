# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'share_progress/version'

Gem::Specification.new do |spec|
  spec.name          = 'share_progress'
  spec.version       = ShareProgress::VERSION
  spec.authors       = ['Neal Donnelly', 'Eric Boersma']
  spec.email         = ['NealJMD@gmail.com', 'eric.boersma@gmail.com']

  spec.summary       = %q{A simple gem designed for creating and retrieving buttons and data on ShareProgress.org}
  spec.homepage      = 'https://github.com/SumOfUs/share_progress'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # ruby version for required named parameters
  spec.required_ruby_version = '>= 2.1'

  # Development Dependencies
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'

  # Runtime Dependencies
  spec.add_runtime_dependency 'httparty'
end
