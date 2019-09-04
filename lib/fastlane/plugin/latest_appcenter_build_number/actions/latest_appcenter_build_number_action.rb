require 'fastlane/action'
require_relative '../helper/latest_appcenter_build_number_helper'

module Fastlane
  module Actions
    class LatestAppcenterBuildNumberAction < Action
      def self.run(params)
        UI.message("The latest_appcenter_build_number plugin is working!")
      end

      def self.description
        "Use AppCenter API to get the latest version and build number for an App Center app"
      end

      def self.authors
        ["Jack Spargo"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Use AppCenter API to get the latest version and build number for an App Center app"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "LATEST_APPCENTER_BUILD_NUMBER_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
