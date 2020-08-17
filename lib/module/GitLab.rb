module Rondabot
  class GitLab < SourceControl
    def initialize params
      super(params)
      if params[:hostname].nil?
        raise ArgumentError.new("'hostname' param is missing!")
      end

      if params[:access_token].nil?
        raise ArgumentError.new("'access_token' param is missing!")
      end

      @hostname = params[:hostname] || "https://gitlab.com"
      @credentials << {
        "type" => "git_source",
        "host" => @hostname,
        "username" => "x-access-token",
        "password" => params[:access_token]
      }
    end

    def hostname
      return @hostname
    end

    def api_endpoint
      return "#{@hostname}/api/v4"
    end

    def create_pull_request params
      pull_request = super(params)
    end
  end
end