# frozen_string_literal: true
# typed: strict

require_relative 'lib/zz/version'

Gem::Specification.new do |spec|
  spec.name          = 'Zz'
  spec.version       = Zz::VERSION
  spec.authors       = ['Fuzz Leonard']
  spec.email         = ['ink@fuzz.ink']

  spec.summary       = 'Simple markdown note management'
  spec.description   = 'A tool for easily creating and managing markdown notes'
  spec.homepage      = 'https://github.com/fuzz/zz'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.7.0'

  spec.files         = Dir.glob(['lib/**/*', 'bin/*', 'README.md', 'LICENSE.txt'])
  spec.bindir        = 'bin'
  spec.executables   = ['zz']
  spec.require_paths = ['lib']

  spec.add_dependency 'sorbet-runtime', '~> 0.5'

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.38'
  spec.add_development_dependency 'rubocop-rake', '~> 0.7'
  spec.add_development_dependency 'sorbet', '~> 0.5'
  spec.add_development_dependency 'tapioca', '~> 0.16'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
