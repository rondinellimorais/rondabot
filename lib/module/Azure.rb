module Rondabot 
  class Azure < SourceControl
    def initialize params
      super(params)
      @project = params[:project]

      if params[:access_token].nil?
        raise ArgumentError.new("'access_token' param is missing!")
      end

      @credentials << {
        "type" => "git_source",
        "host" => "dev.azure.com",
        "username" => "x-access-token",
        "password" => params[:access_token]
      }

      # get organization
      @organization = params[:organization]
      if @organization.nil?
        raise ArgumentError.new("'organization' param is missing!")
      end

      # get npm registry feed id
      @feed_id = params[:feed_id]
      if @feed_id.nil?
        raise ArgumentError.new("'feed_id' param is missing!")
      end

      @credentials << {
        "type" => "npm_registry",
        "registry" => "https://pkgs.dev.azure.com/#{@organization}/#{@feed_id}/_packaging/npm-packages/npm/registry/",
        "token" => "#{@feed_id}:#{params[:access_token]}"
      }
    end

    def repository_uri
      super()

      if @project.nil?
        raise ArgumentError.new("'project' param is missing!")
      end

      return "#{@organization}/#{@project}/_git/#{@repository}"
    end

    def create_pull_request params
      pull_request = super(params)

      if pull_request&.status == 201
        content = JSON[pull_request.body]
        puts "  PR ##{content["pullRequestId"]} submitted"
      else
        puts "  PR already exists or an error has occurred"
      end
    end
  end
end