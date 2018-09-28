require 'fastlane/action'
require_relative '../helper/android_change_package_name_helper'

module Fastlane
  module Actions
    class AndroidChangePackageNameAction < Action
      def self.run(params)
        UI.message("The android_change_package_name plugin is working!")
      end

      def self.description
        "Change the package identifier in the AndroidManifest.xml file"
      end

      def self.authors
        ["yeppao"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "It will permits you to change the package name of your project before the build"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "ANDROID_CHANGE_PACKAGE_NAME_YOUR_OPTION",
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
