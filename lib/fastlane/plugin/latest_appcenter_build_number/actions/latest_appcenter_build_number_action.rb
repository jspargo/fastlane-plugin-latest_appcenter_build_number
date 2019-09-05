require 'json'
require 'net/http'

module Fastlane
  module Actions
    class LatestAppcenterBuildNumberAction < Action
      def self.run(config)
        host_uri = URI.parse('https://api.appcenter.ms')
        http = Net::HTTP.new(host_uri.host, host_uri.port)
        http.use_ssl = true
        list_request = Net::HTTP::Get.new("/v0.1/apps/#{config[:owner_name]}/#{config[:app_name]}/releases")
        list_request['X-API-Token'] = config[:api_token]
        list_response = http.request(list_request)
        releases = JSON.parse(list_response.body)

        if releases.nil?
          UI.error("No versions found for #{config[:app_name]} owned by #{config[:owner_name]}")
          return nil
        end

        releases.sort_by { |release| release['id'] }
        latest_build = releases.first

        if latest_build.nil?
          UI.error("The app has no versions yet")
          return nil
        end

        return latest_build['version']
      end

      def self.description
        "Gets latest version number of the app from AppCenter"
      end

      def self.authors
        ["jspargo", "ShopKeep", "pahnev", "FlixBus (original author)"]
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_token,
                                       env_name: "APPCENTER_API_TOKEN",
                                       description: "API Token for AppCenter Access",
                                       verify_block: proc do |value|
                                         UI.user_error!("No API token for AppCenter given, pass using `api_token: 'token'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :owner_name,
                                       env_name: "APPCENTER_OWNER_NAME",
                                       description: "Name of the owner of the application on AppCenter",
                                       verify_block: proc do |value|
                                         UI.user_error!("No owner name for AppCenter given, pass using `owner_name: 'owner name'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :app_name,
                                       env_name: "APPCENTER_APP_NAME",
                                       description: "Name of the application on AppCenter",
                                       verify_block: proc do |value|
                                         UI.user_error!("No app name for AppCenter given, pass using `app_name: 'app name'`") unless value && !value.empty?
                                       end)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end
    end
  end
end
