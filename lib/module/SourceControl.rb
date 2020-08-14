require "dependabot/omnibus"

module Rondabot
  class SourceControl
    attr_accessor :credentials, :provider

    def initialize params
      @credentials = []
      @provider = params[:provider]

      # A GitHub access token with read access to public repos
      if params[:github_public_token].nil?
        raise ArgumentError.new("'github_public_token' param is missing!")
      end

      @credentials << {
        "type" => "git_source",
        "host" => "github.com",
        "username" => "x-access-token",
        "password" => "#{params[:github_public_token]}"
      }
    end

    def repository_uri
      raise "this method cannot be called directly, do override!"
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

      pull_request = pr_creator.create

      if pull_request&.status == 201
        content = JSON[pull_request.body]
        puts "  PR ##{content["pullRequestId"]} submitted"
      else
        puts "  PR already exists or an error has occurred"
      end
    end

    private
    def get_user_credentials(params)
      _credentials = params[:credentials]
      if _credentials.nil? || _credentials[:username].nil? || _credentials[:password].nil?
        raise ArgumentError.new("'credentials' param is missing! Check your credentials parameter")
      end
      return _credentials
    end
  end
end
  