module Rondabot 
  class Azure < SourceControl
    def initialize params
      super(params)
      @repository = params[:repository]
      @project = params[:project]

      user_credentials = get_user_credentials(params)
      @credentials << {
        "type" => "git_source",
        "host" => "dev.azure.com",
        "username" => user_credentials[:username],
        "password" => user_credentials[:password]
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
        "token" => "#{@feed_id}:#{user_credentials[:password]}"
      }
    end

    def repository_uri
      if @repository.nil?
        raise ArgumentError.new("'repository' param is missing!")
      end

      if @project.nil?
        raise ArgumentError.new("'project' param is missing!")
      end

      return "#{@organization}/#{@project}/_git/#{@repository}"
    end
  end
end