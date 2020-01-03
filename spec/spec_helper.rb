$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'simplecov'
require 'webmock'
require 'webmock/rspec'

SimpleCov.minimum_coverage 80
SimpleCov.start

def stub_request(*args)
  WebMock::API.stub_request(*args)
end

# This module is only used to check the environment is currently a testing env
module SpecHelper
end

require 'fastlane' # to import the Action super class
require 'fastlane/plugin/latest_appcenter_build_number' # import the actual plugin

Fastlane.load_actions # load other actions (in case your plugin calls other actions or shared values)
