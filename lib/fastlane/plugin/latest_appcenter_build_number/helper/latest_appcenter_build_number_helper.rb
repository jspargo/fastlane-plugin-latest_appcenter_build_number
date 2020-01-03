require 'fastlane_core/ui/ui'

module Fastlane
  module Helper
    class LatestAppcenterBuildNumberHelper
      # class methods that you define here become available in your action
      # as `Helper::LatestAppcenterBuildNumberHelper.your_method`
      #
      def self.check_valid_name(name)
        regexp = /^[a-zA-Z0-9\-]+$/i
        return regexp.match?(name)
      end
    end
  end
end
