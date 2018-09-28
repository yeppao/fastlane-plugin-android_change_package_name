require 'fastlane/action'
require_relative '../helper/android_change_package_name_helper'

module Fastlane
  module Actions
    class AndroidChangePackageNameAction < Action
      def self.run(params)
        require 'nokogiri'

        packageName = params[:package_name]
        manifest = params[:manifest]

        doc = File.open(manifest) { |f|
          @doc = Nokogiri::XML(f)

          @doc.css("manifest").each do |response_node|
            response_node["package"] = packageName

            UI.message("Updating package name to: #{packageName}")
          end

          File.write(manifest, @doc.to_xml)
        }
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
          FastlaneCore::ConfigItem.new(key: :package_name,
                                  env_name: "",
                               description: "New package name",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :manifest,
                                  env_name: "",
                               description: "Location of your project AndroidManifest.xml",
                                  optional: false,
                                      type: String,
                             default_value: "app/src/main/AndroidManifest.xml")
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
