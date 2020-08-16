require "dependabot/omnibus"
require "json"

module Rondabot
  class Core
    def initialize params
      @provider = params[:provider]

      case @provider
        when 'azure'
          @source_control = Rondabot::Azure.new(params)
        when 'gitlab'
          # @source_control = Rondabot::GitLab.new(params)
          raise ArgumentError.new("gitlab available soon :)")
        when 'github'
          @source_control = Rondabot::GitHub.new(params)
        else
          raise ArgumentError.new("'provider' param is missing! The available values are: azure, gitlab or github.")
      end
    end

    def start
      package_manager = "npm_and_yarn"
      source = Dependabot::Source.new(
        provider: @provider,
        repo: @source_control.repository_uri
      )

      fetcher = @source_control.clone(source)
      files = fetcher.files
      commit = fetcher.commit

      # keep only safe files
      exclude_files = [
        'yarn.lock',
        'package-lock.json'
      ]

      dependency_files = files.select do |f|
        !exclude_files.include?(f.name)
      end

      parser = Dependabot::FileParsers.for_package_manager(package_manager).new(
        dependency_files: dependency_files,
        source: source,
        credentials: @source_control.credentials,
      )

      dependencies = parser.parse

      # Get the audit report to find out which
      # dependencies are vulnerable
      npm_and_yarn = Rondabot::NpmAndYarn.new(dependencies)
      audit_obj = npm_and_yarn.audit()

      #r report
      print_audit_table(audit_obj)

      # for each dependency, the best version for the
      # upgrade must be analyzed
      audit_obj.each do |audit|
        best_version_to_go = Rondabot::Version.next(
          audit[:current_version],
          audit[:patched_versions]
        )

        dependency = Dependabot::Dependency.new(
          name: audit[:name],
          version: best_version_to_go.version,
          requirements: [{:requirement=>best_version_to_go.version, :file=>"package.json", :groups=>["dependencies"], :source=>nil}],
          previous_requirements: [{:requirement=>audit[:current_version].version, :file=>"package.json", :groups=>["dependencies"], :source=>nil}],
          package_manager: package_manager
        )
        
        updater = Dependabot::FileUpdaters.for_package_manager(package_manager).new(
          dependencies: [dependency],
          dependency_files: dependency_files,
          credentials: @source_control.credentials,
        )

        @source_control.create_pull_request(
          updater: updater,
          base_commit: commit,
          dependencies: [dependency],
          source: source
        )
      end
    end

    def print_audit_table audit_obj
      if !audit_obj.empty?
        puts "\nThe following dependencies are considered vulnerable."
        puts "=============="
        audit_obj.each do |audit|
          puts "#{audit[:name]}@#{audit[:current_version].version}"
        end
        puts "\n"
      end
    end
  end
end