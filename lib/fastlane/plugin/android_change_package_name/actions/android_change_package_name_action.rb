require 'fastlane/action'
require_relative '../helper/android_change_package_name_helper'

module Fastlane
  module Actions
    class AndroidChangePackageNameAction < Action
      def self.run(params)
        require 'nokogiri'

        path = params[:path]
        packageName = params[:package_name]
        manifest = params[:manifest]

        doc = File.open(manifest) { |f|
          @doc = Nokogiri::XML(f)

          originalPackageName = nil

          @doc.css("manifest").each do |response_node|
            originalPackageName = response_node["package"]
            response_node["package"] = packageName

            UI.message("Updating package name to: #{packageName}")
          end

          if  originalPackageName != packageName
            File.write(manifest, @doc.to_xml)

            folder = originalPackageName.gsub('.', '/')
            new_folder = packageName.gsub('.', '/')
            new_folder_path = "#{path}/app/src/main/java/#{new_folder}"

            FileUtils::mkdir_p new_folder_path

            java_sources = Dir.glob("#{path}/app/src/main/java/#{folder}/*.java")
            java_sources.each do |file|
              FileUtils.mv file, new_folder_path
            end

            Bundler.with_clean_env do
              sh "find #{path}/app/src -name '*.java' -type f -exec sed -i '' 's/#{originalPackageName}/#{packageName}/' {} \\;"
              sh "find #{path}/app -name 'build.gradle' -type f -exec sed -i '' 's/#{originalPackageName}/#{packageName}/' {} \\;"
            end
          end

          UI.message("#{originalPackageName} successfully updated to #{packageName}")
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
                             default_value: "app/src/main/AndroidManifest.xml"),
          FastlaneCore::ConfigItem.new(key: :path,
                                  env_name: "",
                                  description: "Path of root Android project folder",
                                  is_string: true,
                                  optional: false,
                                  default_value: ".")
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end
    end
  end
end
