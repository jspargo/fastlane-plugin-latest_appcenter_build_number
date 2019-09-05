require 'json'
require 'net/http'
require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Actions
    class LatestAppcenterBuildNumberAction < Action
      def self.run(config)
        app_name = config[:app_name]
        owner_name = config[:owner_name]
        if app_name.nil? || owner_name.nil?
          owner_and_app_name = get_owner_and_app_name(config[:api_token])
          app_name = owner_and_app_name[0]
          owner_name = owner_and_app_name[1]
        end

        host_uri = URI.parse('https://api.appcenter.ms')
        http = Net::HTTP.new(host_uri.host, host_uri.port)
        http.use_ssl = true
        list_request = Net::HTTP::Get.new("/v0.1/apps/#{owner_name}/#{app_name}/releases")
        list_request['X-API-Token'] = config[:api_token]
        list_response = http.request(list_request)

        if list_response.kind_of? Net::HTTPForbidden
          UI.error("API Key not valid for #{owner_name}. This will be because either the API Key or the owner_name are incorrect")
          return nil
        end

        releases = JSON.parse(list_response.body)
        if releases.nil?
          UI.error("No versions found for #{app_name} owned by #{owner_name}")
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
                                       optional: true,
                                       description: "Name of the owner of the application on AppCenter",
                                       verify_block: proc do |value|
                                         UI.user_error!("No owner name for AppCenter given, pass using `owner_name: 'owner name'`") unless value && !value.empty?
                                       end),
          FastlaneCore::ConfigItem.new(key: :app_name,
                                       env_name: "APPCENTER_APP_NAME",
                                       optional: true,
                                       description: "Name of the application on AppCenter",
                                       verify_block: proc do |value|
                                         UI.user_error!("No app name for AppCenter given, pass using `app_name: 'app name'`") unless value && !value.empty?
                                       end)
        ]
      end

      def self.is_supported?(platform)
        [:ios, :android].include?(platform)
      end

      def self.get_owner_and_app_name(api_token)
        apps = get_apps(api_token)
        app_names = apps.map { |app| app['name'] }.sort
        selected_app_name = UI.select("Select your project: ", app_names)
        selected_app = apps.select { |app| app['name'] == selected_app_name }.first

        name = selected_app['name'].to_s
        owner = selected_app['owner']['name'].to_s
        return name, owner
      end

      def self.get_apps(api_token)
        host_uri = URI.parse('https://api.appcenter.ms')
        http = Net::HTTP.new(host_uri.host, host_uri.port)
        http.use_ssl = true
        apps_request = Net::HTTP::Get.new("/v0.1/apps")
        apps_request['X-API-Token'] = api_token
        apps_response = http.request(apps_request)
        apps = JSON.parse(apps_response.body)
        return apps
      end
    end
  end
end
