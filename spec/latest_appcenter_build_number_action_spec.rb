describe Fastlane::Actions::LatestAppcenterBuildNumberAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The latest_appcenter_build_number plugin is working!")

      Fastlane::Actions::LatestAppcenterBuildNumberAction.run(nil)
    end
  end
end
