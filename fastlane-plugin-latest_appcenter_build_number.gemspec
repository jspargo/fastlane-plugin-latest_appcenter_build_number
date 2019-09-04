# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/latest_appcenter_build_number/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-latest_appcenter_build_number'
  spec.version       = Fastlane::LatestAppcenterBuildNumber::VERSION
  spec.author        = 'Jack Spargo'
  spec.email         = 'jspargo@shopkeep.com'

  spec.summary       = 'Use AppCenter API to get the latest version and build number for an App Center app'
  spec.homepage      = "https://github.com/jspargo/fastlane-plugin-latest_appcenter_build_number"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.121.1')
end
