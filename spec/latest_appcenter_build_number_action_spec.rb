def stub_get_releases_success(status)
  success_json = JSON.parse(File.read("spec/fixtures/valid_release_response.json"))
  stub_request(:get, "https://api.appcenter.ms/v0.1/apps/owner-name/App-Name/releases")
    .to_return(status: status, body: success_json.to_json, headers: { 'Content-Type' => 'application/json' })
end

def stub_get_releases_not_found(status)
  not_found_json = JSON.parse(File.read("spec/fixtures/not_found.json"))
  stub_request(:get, "https://api.appcenter.ms/v0.1/apps/owner-name/App-Name/releases")
    .to_return(status: status, body: not_found_json.to_json, headers: { 'Content-Type' => 'application/json' })
end

def stub_get_releases_forbidden(status)
  forbidden_json = JSON.parse(File.read("spec/fixtures/forbidden.json"))
  stub_request(:get, "https://api.appcenter.ms/v0.1/apps/owner-name/App-Name/releases")
    .to_return(status: status, body: forbidden_json.to_json, headers: { 'Content-Type' => 'application/json' })
end

def stub_get_apps_success(status)
  success_json = JSON.parse(File.read("spec/fixtures/valid_apps_response.json"))
  stub_request(:get, "https://api.appcenter.ms/v0.1/apps")
    .to_return(status: status, body: success_json.to_json, headers: { 'Content-Type' => 'application/json' })
end

describe Fastlane::Actions::LatestAppcenterBuildNumberAction do
  describe '#run' do
    before :each do
      allow(FastlaneCore::FastlaneFolder).to receive(:path).and_return(nil)
    end

    it "raises an error if no api token was given" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          latest_appcenter_build_number(
            owner_name: 'owner-name',
            app_name: 'App-Name'
          )
        end").runner.execute(:test)
      end.to raise_error("No API token for AppCenter given, pass using `api_token: 'token'`")
    end

    it "raises an error if the app does not exist for a given owner/API Key" do
      stub_get_apps_success(200)
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          latest_appcenter_build_number(
            api_token: '1234',
            app_name: 'App-Name-Does-Not-Exist'
          )
        end").runner.execute(:test)
      end.to raise_error("No app 'App-Name-Does-Not-Exist' found for owner ")
    end

    # it "raises an error if no app name was given" do
    #   stub_get_apps_success(200)
    #   expect do
    #     Fastlane::FastFile.new.parse("lane :test do
    #       latest_appcenter_build_number(
    #         api_token: '1234',
    #         owner_name: 'owner-name',
    #       )
    #     end").runner.execute(:test)
    #   end.to raise_error("No App name given, pass using `app_name: 'app name'`")
    # end

    it "raises an error if the app name contains spaces" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          latest_appcenter_build_number(
            api_token: '1234',
            owner_name: 'owner-name',
            app_name: 'App Name'
          )
        end").runner.execute(:test)
      end.to raise_error("The `app_name` ('App Name') cannot contains spaces and must only contain alpha numeric characters and dashes")
    end

    it "raises an error if the app name contains special characters" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          latest_appcenter_build_number(
            api_token: '1234',
            owner_name: 'owner-name',
            app_name: 'App-Name!@£$'
          )
        end").runner.execute(:test)
      end.to raise_error("The `app_name` ('App-Name!@£$') cannot contains spaces and must only contain alpha numeric characters and dashes")
    end

    it "raises an error if the owner name contains spaces" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          latest_appcenter_build_number(
            api_token: '1234',
            owner_name: 'owner name',
            app_name: 'App-Name'
          )
        end").runner.execute(:test)
      end.to raise_error("The `owner_name` ('owner name') cannot contains spaces and must only contain lowercased alpha numeric characters and dashes")
    end

    it "raises an error if owner name contains special characters" do
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          latest_appcenter_build_number(
            api_token: '1234',
            owner_name: '**/Owner name!!',
            app_name: 'App-Name'
          )
        end").runner.execute(:test)
      end.to raise_error("The `owner_name` ('**/Owner name!!') cannot contains spaces and must only contain lowercased alpha numeric characters and dashes")
    end

    it "raises an error if the app name does not exist for an owner/account" do
      stub_get_releases_forbidden(403)
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          latest_appcenter_build_number(
            api_token: '1234',
            owner_name: 'owner-name',
            app_name: 'App-Name'
          )
        end").runner.execute(:test)
      end.to raise_error("API Key not valid for 'owner-name'. This will be because either the API Key or the `owner_name` are incorrect")
    end

    it "raises an error if the owner/account name or API key are incorrect" do
      stub_get_releases_not_found(404)
      expect do
        Fastlane::FastFile.new.parse("lane :test do
          latest_appcenter_build_number(
            api_token: '1234',
            owner_name: 'owner-name',
            app_name: 'App-Name'
          )
        end").runner.execute(:test)
      end.to raise_error("No app or owner found with `app_name`: 'App-Name' and `owner_name`: 'owner-name'")
    end

    it "returns the version number correctly" do
      stub_get_releases_success(200)
      build_number = Fastlane::FastFile.new.parse("lane :test do
        latest_appcenter_build_number(
          api_token: '1234',
          owner_name: 'owner-name',
          app_name: 'App-Name'
        )
      end").runner.execute(:test)
      expect(build_number).to eq('1.0.4.105')
    end
  end
end
