require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class LatestAppcenterBuildNumberHelper
      # class methods that you define here become available in your action
      # as `Helper::LatestAppcenterBuildNumberHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the latest_appcenter_build_number plugin helper!")
      end
    end
  end
end
