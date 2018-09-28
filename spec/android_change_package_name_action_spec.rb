describe Fastlane::Actions::AndroidChangePackageNameAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The android_change_package_name plugin is working!")

      Fastlane::Actions::AndroidChangePackageNameAction.run(nil)
    end
  end
end
