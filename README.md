# latest_appcenter_build_number plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-latest_appcenter_build_number)
[![Gem Version](https://badge.fury.io/rb/fastlane-plugin-latest_appcenter_build_number.svg)](https://badge.fury.io/rb/fastlane-plugin-latest_appcenter_build_number)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-latest_appcenter_build_number`, add it to your project by running:

```bash
fastlane add_plugin latest_appcenter_build_number
```

## About latest_appcenter_build_number

Use AppCenter API to get the latest version and build number for an App Center app

## Replacing `latest_hockey_build_number`

If you're using this as a direct replacement for the old `latest_hockey_build_number` having migrated your apps to AppCenter, you should change instances of this:
```
latest_hockey_build_number(api_token: "my-HOCKEY-api-token", bundle_id: "com.example.my-awesome-app")
```
to this:
```
latest_appcenter_build_number(
  api_token: "my-APPCENTER-api-token", # note that this will need to be generated from here: https://appcenter.ms/settings/apitokens
  owner_name: "owner-name",
  app_name: "My-Awesome-App"
)
```
To find out your `app_name` correctly, head to https://appcenter.ms/apps?os=All. Your `app_name` will most likely be what's listed under the 'Name' column but with hyphens instead of whitespace.

To find out your `owner_name` correctly, head to https://appcenter.ms/settings/profile. Your `owner_name` will most likely be what's listed under the 'username' field.

## Example

You can fetch the latest version for a given app with the following command in your Fastfile:
```
version_number = latest_appcenter_build_number(
  api_token: "my-APPCENTER-api-token", # note that this will need to be generated from here: https://appcenter.ms/settings/apitokens
  owner_name: "owner-name",
  app_name: "My-Awesome-App"
)
```
You can then use `version_number` for whatever purpose you required, including updating the shortVersion or buildNumber of your Xcode project.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
