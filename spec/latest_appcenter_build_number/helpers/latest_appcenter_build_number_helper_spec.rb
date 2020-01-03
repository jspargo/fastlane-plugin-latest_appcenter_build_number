describe Fastlane::Helper::LatestAppcenterBuildNumberHelper do
  let(:helper) { Fastlane::Helper::LatestAppcenterBuildNumberHelper }

  describe '#check_valid_name' do
    context 'when the name is valid' do
      let(:result) { helper.check_valid_name('App-Name') }
      it { expect(result).to be true }
    end

    context 'when the name is not valid' do
      let(:result) { helper.check_valid_name('App-Name!@£$') }
      it { expect(result).to be false }
    end

    context 'when the name is not valid' do
      let(:result) { helper.check_valid_name('App Name') }
      it { expect(result).to be false }
    end
  end
end
