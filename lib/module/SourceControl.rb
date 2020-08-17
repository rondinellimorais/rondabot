require "dependabot/omnibus"

module Rondabot
  class SourceControl
    attr_accessor :credentials, :provider

    def initialize params
      @credentials = []
      @provider = params[:provider]
      @repository = params[:repository]

      # When the repository's visibility is public,
      # the `github_token` must be an access token with read access to the public repositories.
      #
      # When repository visibility is private,
      # the `github_token` must be an access token with full control of private repositories.
      if params[:github_token].nil?
        raise ArgumentError.new("'github_token' param is missing!")
      end

      @credentials << {
        "type" => "git_source",
        "host" => "github.com",
        "username" => "x-access-token",
        "password" => "#{params[:github_token]}"
      }
    end

    def repository_uri
      if @repository.nil?
        raise ArgumentError.new("'repository' param is missing!")
      end
      return @repository
    end

    def clone source
      return Dependabot::FileFetchers.for_package_manager("npm_and_yarn").new(
        source: source,
        credentials: self.credentials,
      )
    end

    def create_pull_request params
      files = params[:updater].updated_dependency_files
      pr_creator = Dependabot::PullRequestCreator.new(
        source: params[:source],
        base_commit: params[:base_commit],
        dependencies: params[:dependencies],
        files: files,
        credentials: self.credentials,
        label_language: true
      )

      return pr_creator.create
    end

    def hostname
      nil
    end

    def api_endpoint
      nil
    end
  end
end
  