module Rondabot
  class GitLab < SourceControl
    def initialize params
      super(params)

      # get the user credentials
      # user_credentials = get_user_credentials(params)
    end

    def repository_uri
      raise "not implemented"
    end
  end
end